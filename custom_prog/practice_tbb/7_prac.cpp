#include <bits/stdc++.h>
#include "tbb/blocked_range.h"
#include "tbb/parallel_for.h"
#include "tbb/tbb.h"

using namespace std;
using namespace tbb;


class apply_transform{

vector<int> array;

public:
apply_transform(int *a, int n): array(a, a+n) {}

void operator()( const blocked_range& r ) const{

for(int i=r.begin(); i!=r.end();i++){

	cout<<i<<" "<<array[i]<<endl;
 }
}


};


int main(){

int n;
cin>>n;

int *arr=(int *) malloc(sizeof(int)*n);

for(int i=0;i<n;i++)
cin>>arr[i];

apply_transform bt=apply_transform(arr, n);

parallel_for(blocked_range(0,n), bt);

return 0;

}


