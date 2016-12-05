source('Convolver.R')
library(microbenchmark)

## run it
kernel1 <- c(1,3,1)/5
kernel2 <- c(2,1,2)/5
kernel.long <- rnorm(1e3)
.nn = 5
## ramp with gap
dat <- c(1:.nn, 0, .nn:1)
## more so
.nlong = 1e4
dat.long <- c(1:.nlong, 0, .nlong:1)

the_test <- Convolver$new(data=dat/sum(dat))
the_test$convolve(kernel1, loud=T)
the_test$convolve(kernel2, loud=T)

long1 <- Convolver$new(data=dat.long)
long2 <- long_test1$copy()
microbenchmark(times=1e3, 
    list=list(
        aa=long1$convolve(kernel.long),
        bb=long2$convolve(kernel.long, do.list=T)
    )
)
