#This script is to allocate all threads and distribute all threads equally among processors

: '
if there are
Threads per core: p
Core per Socket: q
Socket: r

then

maximum thread count is p*q*r

On each core you can schedule p threads that can run simultaneously

' 
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
#last_10_pro=`ps --no-header -eLo cmd,tid,ni |  awk '!/grep/ / 0/{print $3 " " $4}'`
last_10_pro=`ps --no-header -eLo tid,ni |  awk '/  0/ {print $1 " " $2}'`
#last_10_pro=`echo $last_10_pro | awk ``
echo $last_10_pro
process_arr=($last_10_pro)
num_rows=${#process_arr[@]}
num_process=$(($num_rows/2))
echo $num_process
#Assigning processes to each core
assign_num_process=`python -c "from math import ceil; print (ceil($num_process/$num_cores))"`
echo $assign_num_process

#core_num represents the core id to which process has to be assigned in other words it behave like priority assigned to a process or niceness 
core_num=0
for (( i=0; i<${num_rows}; i=i+$(( 2*${assign_num_process} )) ));
do
	for (( j=0; j<2*${assign_num_process} && $(($i+$j))<${num_rows} ; j=j+2 ));
	do
		# i+j represent the process index in process array for core i 
		pid=${process_arr[$(($j+$i))]}
		niceness=${process_arr[$(($i+$j+1))]}
		echo $pid, $niceness, $core_num
		#renice $core_num -p $pid 
		taskset -pc $core_num $pid
	done
	core_num=$(($core_num+1))
done 

