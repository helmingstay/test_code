#include <cmath>
#include <Rcpp.h>
using Rcpp::List;
using Rcpp::NumericVector;

// [[Rcpp::export]]
NumericVector myfun(double X, double r, double K, double sigma, double delta_t, ...) {
    GetRNGstate();
    double S = exp(-r*delta_t);
    double logeps = (sigma > 0.0) ? R::rnorm(0,sigma) : 0.0;
    PutRNGstate();
    NumericVector ret; 
    // return named vector
    ret["X"] = pow(K,(1-S))*pow(X,S)*exp(logeps);
    return ret;
}
