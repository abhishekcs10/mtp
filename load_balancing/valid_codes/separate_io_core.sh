#!/bin/bash
all_threads=`ps --no-headers -eLo tid |  awk '{print $1}'`
io_threads=`sudo iotop -boqqq --iter=15 | awk '{print $1}' | sort | uniq`
union="$all_threads"" ""$io_threads"
cpu_threads=`echo "${union_arr[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '`

echo $all_threads
echo $io_threads
echo $cpu_threads

io_thread_arr=($io_threads)
num_io_threads=${#io_thread_arr[@]}
cpu_thread_arr=($cpu_threads)
num_cpu_threads=${#cpu_thread_arr[@]}


num_cores=`grep -c ^processor /proc/cpuinfo`
num_threads_per_core=`lscpu | awk '/Thread/ {print $4}'`
echo $num_cores
echo $num_threads_per_core

for (( i=0; i<$num_io_threads; i=i+1 ));
do
	tid=${io_thread_arr[$i]}
	taskset -pc $(($num_cores-1)) $tid
done

for ((i=0; i<$num_cpu_threads; i=i+1));
do 
	tid=${cpu_thread_arr[$i]}
	if [ $num_cores -gt 2 ]:
	then
		taskset -pc 0-$(($num_cores-2)) $tid
	fi
done

: '
For processes
ps -U root -u root -N -o pid
'



