#This script is to allocate the class of priorities as in linux (-19 to +20 i.e. 40 priority levels) equally among the available cores. Then distribute all threads equally among processors

: '

First give niceness to processes,

then check for max niceness value
distribute this nicessness value equally among cores
use taskset to bind to core specified for that particular niceness

if there are
Threads per core: p
Core per Socket: q
Socket: r

then

maximum thread count is p*q*r

On each core you can schedule p threads that can run simultaneously

' 
num_priorities=40
highest_priority=-20
#lets take assignable priority to be between 0 to 19
init_assignable_priority=0
num_cores=`grep -c ^processor /proc/cpuinfo`
: '
lscpu | awk '/Thread/ {print $4}'

In / / there is regular expression that matches then in {} you give what to print, $0 is whole line and each word is a column
'

num_threads_per_core=`lscpu | awk '/Thread/ {print $4}'`
echo $num_cores
echo $num_threads_per_core

: '
To display list of process with 0 niceness

ps ax -o pid,ni | awk \/ 0/ 
'
: '
To display list of process run as normal user
ps -U root -u root -N
'
#last_10_pro=`ps -U root -u root -N -o pid,ni | tail` #this extracts process ids only
#last_10_pro=`ps -eLo tid,ni | tail` #this extracts thread level process ids
#last_10_pro=`ps -eLo cmd,tid,ni | grep burn_cycles.py |  awk '!/grep/{print $3 " " $4}'` #this is to extract thread ids of system level thread
last_10_pro=`ps -axo cmd,pid,ni | grep burn_cycles.py |  awk '!/grep/{print $3 " " $4}'` #this is to extract pids
#last_10_pro=`echo $last_10_pro | awk ``
echo $last_10_pro
process_arr=($last_10_pro)
num_rows=${#process_arr[@]}
num_process=$(($num_rows/2))
echo $num_process

##code to renice processes

assign_num_process=1
init_nice=0
if [ $num_cores -ge $num_process ]
then
	j=0
	for (( i=0; i<${num_process}; i=i+1 ));
	do
		pid=${process_arr[$j]}
		echo $core_num, $pid
		#renice $core_num -p $pid
		j=$(($j+2)) 
		core_num=$(($core_num+1))
		init_nice=$(($init_nice+1))
	done
else

: '
################# If number of cores are more than number of priorities available, then take number of cores and assign multiple cores to same priority processes, i.e. number of cores assigned to a particular priority will range as-> floor(number of processors/number of priorities)

else for each core assign a job with a given priority
'

	#Assigning processes to each core
	assign_num_process=`python -c "from math import ceil; print (ceil($num_process/$num_cores))"`
	echo $assign_num_process
	#core_num represents the core id to which process has to be assigned in other words it behave like priority assigned to a process or niceness 
	#core_num=0
	for (( i=0; i<${num_rows}; i=i+$(( 2*${assign_num_process} )) ));
	do
		for (( j=0; j<2*${assign_num_process} && $(($i+$j))<${num_rows} ; j=j+2 ));
		do
			# i+j represent the process index in process array for core i 
			pid=${process_arr[$(($j+$i))]}
			niceness=${process_arr[$(($i+$j+1))]}
			echo $pid, $niceness, $init_nice
			`ls /proc/$pid/task | xargs renice $init_nice -p`
			#renice $core_num -p $pid 
			#taskset -pc $core_num $pid
		done
		init_nice=$(($init_nice+1))
	done 
fi


########################### now init_nice has maximum priority that has been assigned so now use taskset to assign these process to different cpu###########
	for(( i=0; i<${
