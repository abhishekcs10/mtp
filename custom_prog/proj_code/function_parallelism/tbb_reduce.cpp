#include<iostream>
#include<cmath>
#include "tbb/tbb.h"
#include "tbb/blocked_range.h"
#include "tbb/parallel_for.h"
#include "tbb/parallel_reduce.h"

using namespace std;
using namespace tbb;


class task1{
int *arr;
int n;
public:
task1(int *a, int r) : arr(a), n(r){} 

void operator()() const {

long long int sum=0;
for(int i=0;i<n;i++)
sum=sum+(long long int)arr[i];
cout<<sum<<endl;

}

};

class task2{
int *arr;
int n;
public:
task2(int *a, int r) : arr(a), n(r) {} 

void operator()() const{
long long int sum=0;
for(int i=0;i<n;i++)
sum=sum+(long long int)arr[i];
cout<<sum<<endl;
}
};

int main(){

int *arr;
int n;
cin>>n;

arr=(int *) malloc(sizeof(int)*n);

for(int i=0;i<n;i++)
cin>>arr[i];

task_group tg;

tick_count t0=tick_count::now();

tg.run(task1(arr,n));

tick_count t1=tick_count::now();
double ti=(t1-t0).seconds();
cout<<"Time for task t1 "<<ti<<endl;

t0=tick_count::now();

tg.run(task2(arr,n));

t1=tick_count::now();

double tj=(t1-t0).seconds();

cout<<"Time for task t2 "<<tj<<endl;

tg.wait();
cout<<endl<<"Total Time "<<ti+tj<<endl;

return 0;

}
