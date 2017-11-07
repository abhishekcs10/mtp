================
Sniper Tutorial
================

Introduction
=============

Number of cores per node is increasing. So we need to simulate multicore processors using today's technologies

Demands on simulation
-----------------------

- Increasing core counts
	
	- Linear increase in simulator workload 
	- Single-threaded simulator sees a rising gap
		- Workload: increasing target cores
		- available processing power: near-constant single-thread performance of host machine
	- Need to use all cores of the host machine
	- Parallel Simulation

- Increasing cache size
	
	- Need a large working set to fully exercise a large cache
	- Scaled-down application won't exhibit the same behaviour
	- Long runnning simulations are required

Experiment Design In Architecture 
--------------------------------------

- Optimizing the probability of success.
	(finding the best architecture/parameters)

	- Coverage:    how    many    architecture    configuraLons    can    I    run    
	- Confidence:  #benchmarks, re‐runs    for    variable    applicaLons    
	- Accuracy:    simulation model detail vs. runtime     


- How many scenarios can i run

	-  N = total number of simulaLon scenarios 	
	-  d = days until paper deadline    
	-  t = average time per simulaLon    
	-  B = number of benchmarks    
	-  A = number of architectures    

.. math:: N = \frac{d}{t*B*A}

Sniper Simulator
------------------

* Hybrid Simulation Approach
	- Analytical Interval Core Model
	- Micro-architecture structure simulation
	- Branch predictors, caches etc.

* Hardware Validated Pin-based
* Models Multi-core multithreaded running multi‐threaded and multi-program workloads.
* Parallel simulator scales with the number of simulated cores.


TOP SNIPER FEATURES

• Interval Model    
• CPI Stacks and InteracLve VisualizaLon    
• Parallel Multithreaded Simulator    
• x86‐64 and SSE2 support    
• Validated against Core2, Nehalem    
• Thread scheduling and migration    
• Full DVFS support    
• Shared and private caches    
• Modern branch predictor    
• Supports pthreads and OpenMP, TBB, OpenCL, MPI, ...    
• SimAPI and Python interfaces to the simulator    
• Many flavors of Linux supported (Redhat, Ubuntu, etc.)        


SNIPER
========

Download Sniper
-----------------

http://snipersim.org/w/Download
• Download tar.gz
• Git clone    

~/sniper$ export GRAPHITE_ROOT=$(pwd)    
~/sniper$ make    

• Running an application    

.. code-block:: bash
	:linenos:
	
	~/sniper$ ./run-sniper­ ‐- /bin/true    
	~/sniper/test/fft$ make run    


.. note::
	
	Maximum 1024 cores can be simulated.
	Scheduling is done in round robin fashion by default.
	To do custom scheduling of threads read -> `Custom Scheduling <https://groups.google.com/forum/#!topic/snipersim/9dD5pVW_s3w>`_


Integration With Benchmark
------------------------------

- Add Source code
- Add __init__.py file
	- Provides application invocation details
	- Define input set
- Mark ROI(region of interest)
- example in local/pi

