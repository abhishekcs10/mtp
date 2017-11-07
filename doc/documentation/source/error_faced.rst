=========================
Different Types of Error
=========================

Issue
======

**Failed to load shared library libtbb.so.2: No such file or directory**

Solution
=========

```
sudo apt-get install tbb-examples
```

Issue
=======

`Sniper working With INTEL TBB <https://stackoverflow.com/questions/45853094/working-with-intel-tbb-program-using-sniper-simulator>`_


Solution
==========

As far as I can tell, TBB is still working properly in Sniper.

I think the problem you might be having is that detailed simulation can take quite some time, and therefore it might appear as though Sniper is hanging. A quick check with Pin's mix-mt tool shows that the application executes 53B instructions in total, which will take more than a day in detailed simulation. One way to check to see what is going on in Sniper would be to add the -sprogresstrace option to enable the ${SNIPER_ROOT}/scripts/progresstrace.py script.

These examples were run on Ubuntu 12.04.5 LTS (3.13.0-32-generic), using TBB with a gitid of eb6336ab, Sniper 6.1 and Pinplay-2.2-pin-2.14-71313.
A Brief Example
Command line options explained

- Run with 2 cores (-n2)
- Start simulation after 30B instructions of fast forward
- End after simulating 30M instructions
- Use the faster, cache-only Nehalem-Lite core model (-cnehalem-lite) for this example (not typically used for detailed simulation)
- Report progress (progresstrace.py modified to show progress every 10B instructions, -sprogresstrace)

Output
=======


```
${SNIPER_ROOT}/run-sniper -n2 -sstop-by-icount:30000000:30000000000 --roi-script -cnehalem-lite -sprogresstrace -- ${TBB_ROOT}/examples/GettingStarted/sub_string_finder/sub_string_finder_extended

 Done building string.
[STOPBYICOUNT] Starting after 30000000000 instructions
[STOPBYICOUNT] Then stopping after simulating 30000000 instructions in detail
 Done with serial version.
[STOPBYICOUNT] Starting ROI after 30000000005 instructions
[STOPBYICOUNT] Ending ROI after 30000002 instructions (30000000 requested)
[SNIPER] End
[SNIPER] Elapsed time: 316.56 seconds

$ head -n5 sim.out 
                                   | Core 0     | Core 1    
  Instructions                     |   14996162 |   15002407
  Cycles                           |   16365757 |   16365757
  IPC                              |       0.92 |       0.92
  Time (ns)                        |    6152540 |    6152540

```

Detailed Output
================

```
${SNIPER_ROOT}/run-sniper -n2 --no-cache-warming -sstop-by-icount:30000000:30000000000 --roi-script -cnehalem-lite -sprogresstrace -- ${TBB_ROOT}/examples/GettingStarted/sub_string_finder/sub_string_finder_extended
[SNIPER] Start
[STOPBYICOUNT] Starting after 30000000000 instructions
[STOPBYICOUNT] Then stopping after simulating 30000000 instructions in detail
[SNIPER] --------------------------------------------------------------------------------
[SNIPER] Sniper using Pin frontend
[SNIPER] Running in script-driven instrumenation mode (--roi-script)
[SNIPER] Using FAST_FORWARD mode for warmup
[SNIPER] Using CACHE_ONLY mode for detailed
[SNIPER] --------------------------------------------------------------------------------
 Done building string.
[PROGRESS] 10000M instructions, 94977 KIPS, 1.00 IPC
[PROGRESS] 20000M instructions, 95086 KIPS, 1.00 IPC
 Done with serial version.
[STOPBYICOUNT] Starting ROI after 30000000005 instructions
[SNIPER] Enabling performance models
[SNIPER] Setting instrumentation mode to CACHE_ONLY
[PROGRESS] 30000M instructions, 99674 KIPS, 2.00 IPC
[STOPBYICOUNT] Ending ROI after 30000002 instructions (30000000 requested)
[SNIPER] Disabling performance models
[SNIPER] Leaving ROI after 0.58 seconds
[SNIPER] Simulated 30.0M instructions, 28843.6M cycles, 0.00 IPC
[SNIPER] Simulation speed 52057.4 KIPS (26028.7 KIPS / target core - 38.4ns/instr)
[SNIPER] Sampling: executed 0.00% of simulated time in detailed mode
[SNIPER] Setting instrumentation mode to FAST_FORWARD
[SNIPER] End
[SNIPER] Elapsed time: 316.56 seconds

```

