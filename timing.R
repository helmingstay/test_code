## language speed test
## https://github.com/niklas-heer/speed-comparison/blob/master/src/leibniz.cpp

library(microbenchmark)
library(compiler)

nn <- 1e6
f1 <- function(nn)
    4*(1+sum(c(-1,1)/((seq.int(4,2*nn+2,2)-1))))
f2 <- function(nn) 
    4*(1+sum(c(-1,1)/(seq.int(4,2*nn+2,2)-1)))

f3 <- function(nn) {
    x = 1
    ret = 1
    nn = nn+2
    ii = 2;
    while(ii<nn) {
    #for (unsigned i=2u ; i < rounds ; ++i) // use ++i instead of i++
        # // some compilers optimize this better than x *= -1
        x = -x; 
        ret = ret + (x / (2 * ii - 1)); #// double / unsigned = double
        ii = ii+1
    }
    ret =  ret*4;
    ret
}
f1.c <- cmpfun(f1)
f2.c <- cmpfun(f2)
f3.c <- cmpfun(f3)

aa <- microbenchmark(
    f1=f1(nn),
    f1.c=f1.c(nn),
    f2=f2(nn), 
    f2.c=f2.c(nn)
)

bb <- microbenchmark(
    f3=f3(nn),
    f3.c=f3.c(nn)
)
