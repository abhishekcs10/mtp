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
highest_priority=-20
num_assignable_priorities=20
#lets take assignable priority to be between 0 to 19
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

#######################################		get pids	################################################

#last_10_pro=`ps -U root -u root -N -o pid,ni | tail` #this extracts process ids only
#last_10_pro=`ps -eLo tid,ni | tail` #this extracts thread level process ids
#last_10_pro=`ps -eLo cmd,tid,ni | grep burn_cycles.py |  awk '!/grep/{print $3 " " $4}'` #this is to extract thread ids of system level thread
last_10_pro=`ps -axo cmd,pid,ni | grep burn_cycles.py |  awk '!/grep/{print $3 " " $4}'` #this is to extract pids
#last_10_pro=`echo $last_10_pro | awk ``
echo $last_10_pro

################################################	get process array	####################################

process_arr=($last_10_pro)
num_rows=${#process_arr[@]}
num_process=$(($num_rows/2))
echo $num_process

################################################	code to renice processes 	########################################

: '
If there are n process and 20 niceness values then 
ceil(n/20) process will have same niceness value

'
assign_num_process=`python -c "from math import ceil; print (ceil($num_process/$num_assignable_priorities))"`
init_nice=0;
for (( i=0; i<${num_process}; i=i+${assign_num_process} ));
do
	k=0
	for (( j=0; j<${assign_num_process}; j=j+1 ));
	do
		# i+j represent the process index in process array for core i 
		pid=${process_arr[$(($((2*$i)) + $k))]}
		curr_niceness=${process_arr[$(($((2*$i))+$k+1))]}

		echo $pid, $curr_niceness, $init_nice
		ls /proc/$pid/task | xargs renice $init_nice -p
		#renice $init_nice -p $pid 
		k=$(($k+2))
	done
	init_nice=$(($init_nice + 1))
	
done

echo "printed niceness and max niceness is "$init_nice

if [ $num_cores -ge $init_nice ]
then
	for (( i=0; i<${init_nice}; i=i+1 ));
	do
		#tid_list=`ps -eLo tid,ni | awk '/ $i/ {print $1}'`
		str="ps -eLo tid,ni,cmd | awk '! /awk/ && /burn_cycles/ && / "${i}"/ {print \$1}'"
		tid_list=`eval $str`
		thread_arr=($tid_list)
		num_threads=${#thread_arr[@]}
		for (( j=0; j<${num_threads}; j=j+1 ))
		do
			#core_num represents the core id to which process has to be assigned in other words it behave like priority assigned to a process or niceness 
			core_num=$i
			tid=${thread_arr[$j]}
			echo $tid,$core_num
			taskset -pc $core_num $tid
			
		done
	done
else

: '
################# If number of cores are more than number of priorities available, then take number of cores and assign multiple cores to same priority processes, i.e. number of cores assigned to a particular priority will range as-> floor(number of processors/number of priorities)

else for each core assign a job with a given priority
'
	#Assigning processes to each core
	assign_num_niceness=`python -c "from math import ceil; print (ceil($num_cores/$init_nice))"`
	echo $assign_num_niceness
	for (( i=0; i<${num_cores}; i=i+1 ));
	do
		for (( j=0; j<${assign_num_niceness} && $(($i+$j))<${init_nice} ; j=j+1 ));
		do
			# i+j represent the nicess of process that will be assigned to core i 
			niceness=$(($i+$j))
			#tid_list=`ps -eLo tid,ni | awk '/ $niceness/ {print $1}'`
			str="ps -eLo tid,ni,cmd | awk '! /awk/ && /burn_cycles/ && / "${niceness}"/ {print \$1}'"
			tid_list=`eval $str`
			#tid_list=`ps -eLo tid,ni | awk '/burn_cycles/ / $niceness/ {print $1}'`
			thread_arr=($tid_list)
			num_threads=${#thread_arr[@]}
			echo $tid_list
			for (( k=0; k<${num_threads}; k=k+1 ))
			do
			#core_num represents the core id to which process has to be assigned in other words it behave like priority assigned to a process or niceness 
				core_num=$i
				tid=${thread_arr[$k]}
				echo "taskset run on "
				echo $tid " " $j
				taskset -pc $i $tid
			done
			#`ls /proc/$pid/task | xargs renice $init_nice -p`
			#renice $core_num -p $pid 
		done
	done 
fi


########################### now init_nice has maximum priority that has been assigned so now use taskset to assign these process to different cpu###########
