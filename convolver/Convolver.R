library(Rcpp)
sourceCpp('convolve.cpp')

## data defn
Convolver <- setRefClass("Convolver",
	fields = list(
		dat = "numeric", 
		answer = "numeric",
        .list = "list"
	)
)
## setup
Convolver$methods(
    initialize=function(dat=NULL) {
        if (!is.null(dat)) {
            dat <<- dat
        }
    }
)
## main computation
Convolver$methods(
    convolve = function(xx, do.list=F, loud=F) {
        dim_new <- length(xx)+length(dat)-1
        ## only re-alloc if necessary
        if (length(answer) != dim_new) {
            if( loud) {
                cat('## Realloc answer\n')
            }
            answer <<- numeric(dim_new)
        }
        .list$xx <<- xx
        .list$dat <<- dat
        .list$answer <<- answer
        if (do.list) {
            lconvolveCpp(.list)
        } else {
            convolveCpp(xx, dat, answer)
        }
        if( loud) {
            cat(c('Answer: ', round(answer,3), '\n'))
        }
    }
)
