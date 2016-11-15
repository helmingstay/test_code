#pragma once
#include <array>
#include <vector>

//types
using cell_t = float;
using contain_t = std::vector<cell_t>;
//using array_t = std::array<cell_t, the_dim>;

// job size
const size_t    the_dim{100000};
const size_t    max_iter{200};
// local group size
const size_t    the_grp{32};
// other constants
const size_t    offset{2};
const cell_t    the_pow{5.3};
const size_t      the_mod(1e6);
const bool      do_mod{false};
const cell_t      _one{1};
const cell_t      _two{2};

// output helper
template <class T>
void the_output(T & AA, size_t imax=10){
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

contain_t fill(size_t nn, size_t _offset=offset) {
    contain_t ret(nn);
    for (size_t ii{0}; ii<the_dim; ii++){
        ret[ii] = ii+offset;
    }
    return ret;
}
    
