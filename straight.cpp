#include <iostream>
#include <algorithm>
#include <cmath>
#include "const.h"
     
int main(){
    // data structure to work on
	array_t A;
    for (size_t ii{0}; ii<the_dim; ii++){
        A[ii] = ii+offset;
        //B[ii] = the_pow;
    }

    auto make_work = [](float num, float _pow=the_pow){
            return log(std::pow(num,_pow))/log(num) - _pow + num + 1;
            // results below differ between cpp and opencl
            // return std::fmod(std::pow(num,_pow),1e6)+2.0;
    };

	for(size_t ii{0}; ii<max_iter; ii++) {
        std::transform(begin(A), end(A), begin(A), make_work);
    }
 
	//read result C from the device to array C
    the_output(A); 
	return 0;
}
