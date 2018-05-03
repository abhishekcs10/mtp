
https://software.intel.com/en-us/blogs/2008/05/08/porting-openmp-spec-benchmarks-to-tbb


From OpenMP to TBB - some general tips
---------------------------------------

Basically, OpenMP applications contain pragma directives to specify parallelism. They are required to parallelize loops, provide locks and protect data. To port to TBB, we needed to match OpenMP pragmas to TBB classes and templates. Let's consider this very simple loop from **320.equake** test:

#pragma omp parallel for private(i)
    for (i = 0; i < nodes; i++) {
      w2[j][i] = 0;
    }
 }


OpenMP executes the loop in parallel; each thread has its own instance of variable "i". The analogous TBB code is shown below - I encapsulated the loop body in a function object that is passed to the template function tbb::parallel_for. The "i" variable is used as the loop variable in the internal loop in operator().
 
class SVMPLoop1Class
{
    int m_j;
public:
    SVMPLoop1Class (int j):m_j(j) {};
    void operator () ( const tbb::blocked_range<int>& range) const{
        for ( int i = range.begin(); i != range.end(); ++i )
            w2[m_j][i] = 0;
    }
};

SVMPLoop1Class svmp1loop(j);
tbb::parallel_for(tbb::blocked_range<int>(0, nodes), svmp1loop, tbb::auto_partitioner());

TBB adds one more class to the code so it looks more complicated than the original code.  However the tbb::parallel_for call itself looks similar to the original loop. Note that I used tbb::auto_partitioner here to allow TBB to choose the grain size automatically.
The scheme here is common for  #pragma omp parallel for directives. If you have several variables in private directive, just move them to local variables inside the loop function. Shared variables can be copied into data members, like j variable in the example above. The SPEC applications excessively use global variables; I found replacing them by local ones works fine in many cases.
Explicit OpenMP locks can be replaced by TBB mutexes, for example tbb::spin_mutex. Like in this example from **332.ammp**:

OpenMP code:
-------------


omp_set_lock(&(a1->lock));
      ...
omp_unset_lock(&(a1->lock));


TBB code:
------------

{
      // scoped_lock acquires lock on creation
      // and releases it automatically after leaving the scope
      tbb::spin_mutex::scoped_lock lock (a1->spin_mutex);
      ...
}


**Resolving thread ID dependency - tbb::parallel_reduce instead of tbb::parallel_for.**

While I was able to replace 





