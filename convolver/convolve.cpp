#include <Rcpp.h>
using Rcpp::NumericVector;

// [[Rcpp::export]]
void convolveCpp(const NumericVector a, const NumericVector b, NumericVector xab) {
	int na = a.size(), nb = b.size();
	if ( (na + nb-1) != xab.size() ) {
		Rcpp::Rcout << "ab.size: " << na+nb << ", xab.size: " << xab.size() << std::endl;
		Rcpp::stop("Dimension mismatch in convolveCpp");
	};
	// zero-out
	xab.fill(0);
	// convolve
	for (int i = 0; i < na; i++) {
		for (int j = 0; j < nb; j++) {
			xab[i + j] += a[i] * b[j];
		}
	}
}
