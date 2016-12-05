library(Rcpp)
sourceCpp('convolve.cpp')

Convolver <- setRefClass("Convolver",
	fields = list(
		data = "numeric", 
		answer = "numeric"
	),
	methods = list(
		convolve = function(x) {
			dim_new <- length(x)+length(data)-1
			## only re-alloc if necessary
			if (length(answer) != dim_new) {
				cat('## Realloc answer\n')
				answer <<- numeric(dim_new)
			}
			convolveCpp(data, x, answer)
			cat(c('Answer: ', round(answer,3), '\n'))
		}
	)
)

kernel1 <- c(1,3,1)/5
kernel2 <- c(2,1,2)/5
dat <- c(1:5, 0, 5:1)

the_test <- Convolver$new(data=dat/sum(dat))
the_test$convolve(kernel1)
the_test$convolve(kernel2)
