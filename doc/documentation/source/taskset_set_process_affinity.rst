=================================
Make threads Run on specific core
=================================

Run program or process on specific CPU cores on linux
=====================================================

One operating system (OS) support often exploited to run performance-critical applications on multi-core processors is so-called "processor affinity" or "CPU pinning". This is an OS-specific feature that "binds" a running process or program to particular CPU core(s).

Binding a program to specific CPU cores can be beneficial in several scenarios. For example, when an application with highly cache-bound workload runs together with other CPU-intensive jobs, pinning the application to a specific CPU would reduce CPU cache misses. Also, when two processes communicate via shared memory intensively, scheduling both processes on the cores in the same NUMA domain would speed up their performance.

To assign particular CPU cores to a program or process, you can use **taskset**, a command line tool for retrieving or setting a process' CPU affinity on Linux.

Install taskset on Linux
=========================

The taskset tool is part of "util-linux" package in Linux, and most Linux distros come with the package pre-installed by default. If taskset is not available on your Linux system, install it as follows.

To install taskset->

::

	sudo apt-get install util-linux 

View the CPU Affinity of a Running Process
===========================================

To retrieve the CPU affinity information of a process, use the following format. taskset returns the current CPU affinity in a hexadecimal bitmask format.

::

	taskset -p <PID>

For example, to check the CPU affinity of a process with PID 2915:

::

	$ taskset -p 2915 
	pid 2915's current affinity mask: ff

The lowest bit in a hexadecimal bitmask corresponds to core ID 0, the second lowest bit from the right to core ID 1, the third lowest bit to core ID 2, etc. So for example, a CPU affinity "0x11" represents CPU core 0 and 4.

**taskset** can show CPU affinity as a list of processors instead of a bitmask, which is easier to read. To use this format, run taskset with "-c" option. For example:

::

	$ taskset -cp 2915 
	pid 2915's current affinity list: 0-7

Pin a Running Process to Particular CPU Core(s)
================================================

Using taskset, you can "pin" (or assign) a running process to particular CPU core(s). For that, use the following format.

::

	$ taskset -p <COREMASK> <PID>
	$ taskset -cp <CORE-LIST> <PID> 

For example, to assign a process to CPU core 0 and 4, do the following.

::

	$ taskset -p 0x11 9030 

	pid 9030's current affinity mask: ff
	pid 9030's new affinity mask: 11

Or equivalently

::

	 $ taskset -cp 0,4 9030 

Launch a Program on Specific CPU Cores
==========================================

**taskset** also allows you to launch a new program as pinned to specific CPU cores. For that, use the following format.

::

	taskset <COREMASK> <EXECUTABLE>

For example, to launch vlc program on a CPU core 0, use the following command.

::

	$ taskset 0x1 vlc 

Dedicate a Whole CPU Core to a Particular Program
====================================================

While taskset allows a particular program to be assigned to certain CPUs, that does not mean that no other programs or processes will be scheduled on those CPUs. If you want to prevent this and dedicate a whole CPU core to a particular program, you can use "isolcpus" kernel parameter, which allows you to reserve the CPU core during boot.

Add the kernel parameter "isolcpus=<CPU_ID>" to the boot loader during boot or GRUB configuration file. Then the Linux scheduler will not schedule any regular process on the reserved CPU core(s), unless specifically requested with taskset. For example, to reserve CPU cores 0 and 1, add "isolcpus=0,1" kernel parameter. Upon boot, then use taskset to safely assign the reserved CPU cores to your program.

