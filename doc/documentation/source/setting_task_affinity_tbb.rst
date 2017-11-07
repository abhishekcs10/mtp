====================================================
Intel TBB Setting Process and thread Level Affinity
====================================================

For Setting Affinity on Linux OS
===================================

According to the Linux* man pages, sched_setaffinity can be used for the purposes.

::

	int sched_setaffinity(pid_t pid, unsigned int len, unsigned long *mask);
	int sched_getaffinity(pid_t pid, size_t cpusetsize, cpu_set_t *mask);


Setting Affinity in TBB
========================

Reference `Set affinity in Intel TBB <https://stackoverflow.com/questions/28400134/intel-tbb-and-cilk-plus-thread-affinity-on-intel-mic>`_.

It's possible and moreover it is recommended in conjunction with affinity_partitioner on Xeon Phi. Please see the `blog <https://software.intel.com/en-us/blogs/2013/10/31/applying-intel-threading-building-blocks-observers-for-thread-affinity-on-intel>`_ for details. Here is a short code snippet to give you idea how does it look like:

::

	class pinning_observer: public tbb::task_scheduler_observer {
	public:
	pinning_observer();
	/*override*/ void on_scheduler_entry( bool );
	~pinning_observer();
	};

	pinning_observer pinner;
	pinner.observe( true );


More relevant method to bind TBB threads to the cores
=======================================================

Reference: `TBB Thread Bind to core <https://software.intel.com/en-us/forums/intel-threading-building-blocks/topic/294546>`_

**Is there any way of binding the TBB threads to the cores?**

Certainly there is no direct API for this, but IMHO there is a simple workaround if only you have:

- a function to set the affinity of kernel threads - in Linux there is a **pthread_attr_setaffinity_np()** function, on Windows there must be a relative,

- some API for per-thread data - and even if you don't know the API on your system, TBB gives you a great (in my opinion) **enumerable_thread_specific** class.

So now you can have a per-thread data of the form

::

	struct tls{
	int thread_id;
	bool affinity_assigned;
	//... possibly sth more...

	tls (int id) : thread_id(id), affinity_assigned(false) {};
	};


Now set:

::

	enumerable_thread_specific per_thread;

And in each task do:

::

	my = per_thread.local();
	if (!my.affinity_assigned) {
	pthread_attr_set_affinity_np (...);
	my.affinity_assigned = true;
	}


