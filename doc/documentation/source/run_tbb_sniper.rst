=====================================
Executing TBB commands with sniper
=====================================

Sniper command list
======================

::

		run-sniper [-n <ncores (1)>] [-d <outputdir (.)>] [-c <sniper-config>]
		[-c [objname:]<name[.cfg]>,<name2[.cfg]>,...]  [-g <sniper-options>]
		[-s <script>] [--roi] [--roi-script] [--viz] [--perf] [--gdb] [--gdb-wait]
		[--gdb-quit] [--appdebug] [--appdebug-manual] [--appdebug-enable]
		[--power] [--cache-only] [--fast-forward] [--no-cache-warming] [--save-patch]
		[--pin-stats] [--mpi [--mpi-ranks=<ranks>] ]
		{
		--traces=<trace0>,<trace1>,...
		[--response-traces=<resptrace0>,<resptrace1>,...]  | -- <cmdline>
		}


There are a number of ways to simulate applications inside of Sniper.
The traditional mode accepts a command line argument of the application to
run.  Starting with Sniper 2.0, multiple single-threaded workloads to be run
on in Sniper via the SIFT feeder (
--traces
).  Multiple multi-threaded appli-
cations can be run in Sniper as well via SIFT and the
--response-traces
option starting with version 3.04.  This is automatically configured via the
--benchmarks
parameter to
run-sniper
in the integrated benchmarks suite.
In Sniper 4.0, single-node shared-memory MPI applications can now be run
in Sniper

::

-n - Number of simulated cores (overrides the general/ncores configuration option)
-d <dir> — Output directory for all generated files



Running Intel TBB
====================

::

    gcc -O2 -DNDEBUG -o output.out input.cpp -ltbb -lrt 
	


Simple Sniper Command
=======================

::

	run-sniper -n #cores ./output.out
