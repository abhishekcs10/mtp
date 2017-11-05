#include<iostream>
#include "tbb/tbb.h"
#include "tbb/blocked_range.h"
#include "tbb/parallel_for.h"
#include "tbb/parallel_reduce.h"

using namespace std;
using namespace tbb;

class summation_helper{

int *partial_array;

public:

int sum;
void operator()(const blocked_range<int> &r)  {

for(int count=r.begin(); count!=r.end(); count++){
sum+=partial_array[count];
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

parallel_reduce(blocked_range<int>(0,n,5),sh);
cout<<sh.sum<<endl;

}
