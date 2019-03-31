// Includes are order dependent??
//
// [[Rcpp::plugins(pomp)]]
#include <pomp.h>
typedef void (*MAGICFUN)(int,double,double*,double,double*);
MAGICFUN p_reulermultinom = (MAGICFUN) R_GetCCallable("pomp", "reulermultinom");

#include <Rcpp.h>

using Rcpp::List;
using Rcpp::NumericVector;

// [[Rcpp::export]]
List myfun(NumericVector X, double tt, List param, double dt, NumericVector admin, NumericVector dis) {
   GetRNGstate();
   enum Xind{C, S};  // X indices

   int N = X[C] + X[S];

   double mu = param["mu"];
   double trans=0;
   double rate = 1/(1+exp(-mu))*X[C]/N;
   
   //p_reulermultinom(1 , X[S], &rate, dt, &trans);

   double nu = param["nu"];
   double import = Rf_rbinom(admin[tt+1], 1/(1+exp( -nu)));
   double ColDis = floor(X[C]*dis[tt+1]/N);

   std::map<std::string,double> updated;
   updated["C"] = X[C] + trans + import - ColDis;
   updated["S"] = X[S] - trans + admin[tt+1] - import - dis[tt+1] + ColDis;

   PutRNGstate();
   return ColDis;
}
