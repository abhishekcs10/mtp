#include<cstdio>
#include<iostream>
#include<algorithm>
#include<vector>
using namespace std;

int main()
{
vector<int> arr;
int k,n;
cin>>n;
for(int i=0;i<n;i++){
cin>>k;
arr.push_back(k);
}

sort(arr.begin(),arr.end());

for(int i=0;i<arr.size(); i++){

cout<< arr[i]<< endl;

}
return 0;
}
