#include <Rcpp.h>
using Rcpp::NumericVector;
using Rcpp::NumericMatrix;
using Rcpp::List;
using Rcpp::Rcout;

// list getter
// take Rcpp proxy, get SEXP, then construct 
template <class Tin, class Tout>
void setter(Tin in, Tout & set) {
    SEXP tmp(in);
    Tout ret(tmp);
    set = ret;
}

struct Pack {
    Pack(List in) {
        setter(in["xx"], xx);
        setter(in["dat"], dat);
        setter(in["answer"], answer);
        setter(in["a_mat"], a_mat);
    }
    NumericVector xx;
    NumericVector dat;
    NumericVector answer;
    NumericMatrix a_mat;
};

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
    auto answer = ll("answer");
    convolveCpp(xx, dat, answer);
}

// [[Rcpp::export]]
void pconvolveCpp(Pack pp) {
    convolveCpp(pp.xx, pp.dat, pp.answer);
}
