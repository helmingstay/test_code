## Take 2
## based on https://kingaa.github.io/pomp/vignettes/R_v_C.html
## Fail... pomp requires dots
##
## Pass dll + function directly?
## See https://tpetzoldt.github.io/deSolve-compiled/deSolve-compiled.html

library(pomp)
## contains Rcpp myfun defn
sourceCpp('process.cpp', verbose=T, rebuild=T)

## rprocess
gompertz.proc.sim <- function (X, r, K, sigma, delta.t, ...) {
  eps <- exp(rnorm(n=1,mean=0,sd=sigma))
  S <- exp(-r*delta.t)
  c(X=K^(1-S)*X^S*eps)
}

## rmeasure
gompertz.meas.sim <- function(X, tau, ...) {
  c(Y=rlnorm(n=1,meanlog=log(X),sd=tau))
}

## dmeasure
gompertz.meas.dens <- function(X, tau, Y, log, ...) {
  dlnorm(x=Y,meanlog=log(X),sdlog=tau,log=log)
}

## rinit
gompertz.init <- function(X_0, ...) {
  c(X=X_0)
}

## pomp construction via simulation
gomp2R <- simulate(
  times=1:100, t0=0,
  rprocess=discrete_time(myfun,delta.t=1), 
  #rprocess=discrete_time(gompertz.proc.sim,delta.t=1), 
  rmeasure=gompertz.meas.sim,
  dmeasure=gompertz.meas.dens,
  rinit=gompertz.init,
  partrans=parameter_trans(log=c("K","r","sigma","tau")),
  paramnames=c("K","r","sigma","tau"),
  params=c(r=0.1,K=1,sigma=0.1,tau=0.1,X_0=1)
) 
