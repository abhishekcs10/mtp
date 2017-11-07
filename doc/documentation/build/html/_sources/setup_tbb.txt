===============
Setup Intel TBB
===============

Intel TBB Tutorial Reference
=============================

Reference `Tutorial <https://software.intel.com/en-us/tbb-tutorial>`_

To install intel TBB
=======================

Clone tbb repository

::

	git clone https://www.github.com/abhishekcs10/tbb

Goto **tbb** directory

Run following commands

::

	make

Setting Up environment variable
=====================================

::

	CPATH=$HOME/tbb/include


To run intel tbb program
==========================

::

	gcc -O2 -DNDEBUG -o output.out input.cpp -ltbb -lrt 
	

-O2 option tells about the optimizations that are applied at level 2 and these optimizations can be tracked using this option

-DNDEBUG ->

NDEBUG disables assert(), which is part of the C standard library. NS_BLOCK_ASSERTIONS disables NSAssert() which is part of Foundation. You generally will require both if you have both kinds of assertions in your code.

The first -D is for "define". -DNDEBUG means "define NDEBUG"


