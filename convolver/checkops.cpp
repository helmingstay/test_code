#include <Rcpp.h>
using namespace Rcpp;
// [[Rcpp::export]]
void checkops(NumericMatrix a_mat, NumericVector a_vec){
    // no BC
    auto aa = a_mat(1,2);
    // not defined?
    // auto aa1 = a_mat(1);
    // BC
    auto bb = a_mat.at(1,2);
    // not defined?
    //auto bb = a_mat.at(1);
    // fails correctly
    // auto bb2 = a_mat.at(1,2,3);
    // compiles, badsauce
    auto cc = a_mat[1,2];
    // ??
    auto dd = a_mat[1,2,3];
    // vector 
    // BC
    auto ff = a_vec(1);
    // also BC, identical to above
    auto gg = a_vec.at(1);
    // fails correctly
    //auto hh = a_vec.at(1,2);
    // No BC
    auto ii = a_vec[1];
    // compiles, badsauce
    auto jj = a_vec[1,2];
    // output
    Rcout << "Matrix: " << aa << bb << cc << dd << std::endl ;
    //
    Rcout << "Vector: " << ff << gg << ii << jj << std::endl;
}

// run with:
// sourceCpp('checkops.cpp');
// checkops(a_mat=matrix(1:9, ncol=3), a_vec=1:20)
