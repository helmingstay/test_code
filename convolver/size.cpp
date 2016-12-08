#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
void test_vec(NumericVector obj){
    Rcout << obj.size();
    Rcout << obj.length();
}

// [[Rcpp::export]]
void test_mat(NumericMatrix obj){
    //problem:
    //Rcout << obj.size();
    Rcout << obj.length();
}
