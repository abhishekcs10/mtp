#include<iostream>
#include<cmath>
#include "tbb/tbb.h"
#include "tbb/blocked_range.h"
#include "tbb/parallel_for.h"
#include "tbb/parallel_reduce.h"

using namespace std;
using namespace tbb;

class summation_helper{

int *partial_array;

public:

long long int sum;
void operator()(const blocked_range<int> &r)  {

for(int count=r.begin(); count!=r.end(); count++){
sum+=(long long int)partial_array[count];
}

}

summation_helper( summation_helper &x, split): partial_array (x.partial_array), sum(0) {}

summation_helper (int *array) : partial_array(array), sum(0) {}

void join (const summation_helper &temp ){
sum+=temp.sum;
}

};

int main(){

int *arr;
int n;
cin>>n;
arr=(int *) malloc(sizeof(int)*n);

for(int i=0;i<n;i++)
cin>>arr[i];

summation_helper sh(arr);
int part=ceil(n/25);
tick_count t0=tick_count::now();
parallel_reduce(blocked_range<int>(0,n,part),sh);
cout<<sh.sum<<endl;

tick_count t1=tick_count::now();
double ti=(t1-t0).seconds();
cout<<ti<<endl;



summation_helper sh1(arr);
t0=tick_count::now();
parallel_reduce(blocked_range<int>(0,n,part),sh1);
cout<<sh.sum<<endl;
t1=tick_count::now();

double tj=(t1-t0).seconds();
cout<<tj<<endl;

cout<<"Total time "<<ti+tj<<endl;

return 0;

}
