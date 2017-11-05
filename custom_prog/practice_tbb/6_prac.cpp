#include <iostream>
#include "tbb/tbb.h"

using namespace std;
using namespace tbb;

class first_class{
const char *str;
public:
first_class(const char *msg) : str(msg) {}

void operator()() const{

cout<<str<<endl;

}

};

int main(){
task_group tg;
tg.run(first_class("this is it"));
tg.run(first_class("this is it again!!"));

tg.wait();

return 0;
}
