#include<iostream>
#include "tbb/tbb.h"

using namespace std;
using namespace tbb;

class first_task: public task{

public:

task *execute(){
cout<<" Hello World\n"<<endl;
return NULL;
}

};

int main(){

task_scheduler_init init(task_scheduler_init::automatic);
first_task& f1=*new(tbb::task::allocate_root()) first_task(); 

tbb::task::spawn_root_and_wait(f1);

int& a=2;
cout<<a<<endl;
return 0;
}
