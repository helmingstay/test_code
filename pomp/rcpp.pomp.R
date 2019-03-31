## inspired by:
# http://lists.r-forge.r-project.org/pipermail/rcpp-devel/2010-September/001089.html 
# and 
# http://lists.r-forge.r-project.org/pipermail/rcpp-devel/attachments/20100910/3084fbf0/attachment.asc

library("Rcpp")
library("pomp")

plug <- Rcpp.plugin.maker(
    LinkingTo='pomp'
)
registerPlugin("pomp", plug)
## compilation fails
sourceCpp('myfun.cpp', verbose=T)

## use it
if(F) {
    .admin = rpois(1,10000)
    .dis  = rpois(1,10000)
    params <- c(mu=log(0.02/0.98), nu=log(0.04/0.96), p=0, S.0=18000, C.0=1500)
    myfun(x=c(C=100,S=1000),t=1,params,test=1, .admin, .dis)
}
