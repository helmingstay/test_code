#include <iostream>
#include <algorithm>
#include <math.h>
#include "const.h"

cell_t make_work(cell_t num){
    if( do_mod) {
        // results differ between cpp and opencl
        return fmod(pow(num,the_pow),the_mod) + _two;
    } else {
        return log(pow(num,the_pow))/log(num) - the_pow + num + _one;
    }
};
 
int main(){
// data structure to work on
auto AA = fill(the_dim);


	for(size_t ii{0}; ii<max_iter; ii++) {
        std::transform(begin(AA), end(AA), begin(AA), &make_work);
    }
 
	//read result C from the device to array C
    the_output(AA); 
	return 0;
}
