#pragma once
#include <array>
// job size
const size_t the_dim{100000};
const size_t max_iter{200};
// local group size
const size_t the_grp{32};
// other constants
const size_t offset{2};
const float the_pow{5.3};
//types
using cell_t = float;
using array_t = std::array<cell_t, the_dim>;

// output helper
auto the_output = [](array_t & AA, size_t imax=10){
	std::cout<<" result: \n";
	for(size_t ii=0;ii<imax;ii++){
		std::cout<<AA[ii]-offset<<" ";
	}
    std::cout<<std::endl;
	for(size_t ii=imax; ii>0; ii--){
		std::cout<<AA[the_dim-ii]-offset-max_iter<<" ";
	}
    std::cout<<std::endl;
};
