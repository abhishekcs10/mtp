#include <iostream>
#include "tbb/tbb.h"

using namespace std;
using namespace tbb;
class second_task: public task{

public:

task* execute(){

cout<<1<<endl;
return NULL;
}

};

class first_task: public task{

public:

task* execute(){

cout<<"Hello world"<<endl;
task_list list1;
list1.push_back(*new (allocate_child()) second_task());
list1.push_back(*new (allocate_child()) second_task());
// important
set_ref_count(3);

spawn_and_wait_for_all(list1);

return NULL;

}

};


int main(){

task_scheduler_init init(task_scheduler_init::automatic);
first_task& f1=*new (tbb::task::allocate_root()) first_task();

task::spawn_root_and_wait(f1);


}
