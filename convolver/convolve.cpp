#include <Rcpp.h>
using Rcpp::NumericVector;

// [[Rcpp::export]]
void convolveCpp(const NumericVector xx, const NumericVector dat, NumericVector ans) {
    size_t nxx = xx.size();
    size_t ndat = dat.size(); 
	if ( (ndat + nxx-1) != ans.size() ) {
		Rcpp::Rcout << "combined size: " << ndat+nxx << ", ans size: " << ans.size() << std::endl;
		Rcpp::stop("Dimension mismatch in convolveCpp");
	};
	// zero-out
	ans.fill(0);
	// convolve
	for (size_t ii = 0; ii < nxx; ii++) {
		for (size_t jj = 0; jj < ndat; jj++) {
			ans[ii + jj] += xx[ii] * dat[jj];
		}
	}
}

// [[Rcpp::export]]
void lconvolveCpp(Rcpp::List ll) {
    auto xx = ll("xx");
    auto dat = ll("dat");
    auto ans = ll("answer");
    convolveCpp(xx, dat, ans);
}
