============
Sniper Setup
============

Dependencies
===============

To setup sniper following are the setup dependencies->

Worked well on 

- Ubuntu 12.04
- Install following packages on Ubuntu 12.04

::

	sudo apt-get install zlib1g-dev libbz2-dev g++ libsqlite3-dev  libboost-dev  m4 \
	xsltproc libx11-dev libxext-dev libxt-dev libxmu-dev  libxi-dev gfortran

Make a folder **sniper** where every component needed for sniper is stored. All the paths would relative to this sniper folder only i.e. **sniper/folder_a** means /path/to/sniper/folder_a

Download Sniper source 
========================

- You should request the Download link of sniper simulator from their website" snipersim.org" and wait until they send the download link  to your Email
- I downloaded the latest version sniper 6.1 (.tbz file) and extracted it and renamed folder **sniper/sniper_6.1** to **sniper/sniper** (with respect to sniper folder i.e. extracted tbz file inside sniper folder previous made and renamed the extracted folder to sniper so there would be sniper/sniper folder
- you can use the terminal to install and extract sniper by using:

::
      open terminal by pressing  Ctrl + Alt + T
      type :cd Downloads
      then write : wget < download link you got by mail>

then extract it as i wrote previously.


Download Pin Instrumentation Tool
==================================

- I installed the latest version but it is incompatible, so, i installed PIN 71313  as sniper team guide us in one topic in the group,
- You can download it from this link `Pin Tool <https://software.intel.com/en-us/articles/pin-a-binary-instrumentation-tool-downloads>`_
- Then i extracted it to a folder named sniper/pin_kit, i created this folder in a sniper folder.
- notice – you now have 2 folders in you sniper dir – pin and pin_kit

Download Boost
===============

- Download Boost (it might work without this step..)
- This link is usefull:  `Boost_1.59.0 <http://sourceforge.net/projects/boost/files/boost/1.59.0/>`_.
- I installed the latest version 1_59_0 then extracted it and moved it in the sniper folder


Install sniper
==============

- Now your environment is ready for installing sniper,
- Go to terminal and cd sniper

::

	~/sniper$ make -j 4 #(for 4 cores)  this number is dependent on your processor 
	cores in your machine.

verify installation by applying a test run :

::

	~/sniper$ cd test/fft
	~/sniper/test/fft$ make run


Add Environment Variable
===========================

::

	export PATH=${PATH}:${HOME}/sniper/sniper
	SNIPER_ROOT=$PATH:${HOME}/sniper/sniper

*Setup Completed*



