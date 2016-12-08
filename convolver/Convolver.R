library(Rcpp)
sourceCpp('convolve.cpp')

## data defn
Convolver <- setRefClass("Convolver",
	fields = list(
		dat = "numeric", 
		answer = "numeric",
        ldat = "list"
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
    convolve = function(xx, 
        do=c('sep','list','pack'),
        loud=F
    ) {
        dim_new <- length(xx)+length(dat)-1
        ## only re-alloc if necessary
        if (length(answer) != dim_new) {
            if( loud) {
                cat('## Realloc answer\n')
            }
            answer <<- numeric(dim_new)
        }
        ldat$xx <<- xx
        ldat$dat <<- dat
        ldat$answer <<- answer
        ldat$a_mat <<- dat %*% dat
        do <- match.arg(do)
        switch(do,
            sep=convolveCpp(xx, dat, answer),
            list=lconvolveCpp(ldat),
            pack=pconvolveCpp(ldat)
        )
        if( loud) {
            cat(c('Answer: ', round(answer,3), '\n'))
        }
    }
)
