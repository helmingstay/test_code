source('Convolver.R')
library(microbenchmark)

## run it
kernel1 <- c(1,3,1)/5
kernel2 <- c(2,1,2)/5
kernel.long <- rnorm(1e4)
.nn = 5
## ramp with gap
dat <- c(1:.nn, 0, .nn:1)
## more so
.nlong = 1e5
dat.long <- c(1:.nlong, 0, .nlong:1)
## define longer test
the_test <- Convolver$new(dat/sum(dat))
the_test$convolve(kernel1, loud=T)
the_test$convolve(kernel2, loud=T)

long1 <- Convolver$new(dat.long)
long2 <- long1$copy()
## run benchmark
timings = microbenchmark(times=1e6, 
    list=list(
        not.list=long1$convolve(kernel.long),
        do.list=long2$convolve(kernel.long, do.list=T)
    )
)

## plot:
library(lattice)
.plot <- bwplot(
    time ~ expr, timings, scales=list(y=list(log=T))
)
plot(.plot)
