pars <- within(list(), {
    npair = 10
    ## transition rate
    q = 0.05
    prob=list(S=0.2, I=0.8)
    tmax=20
})
## works
obs <- hmmBinom(size=1, prob=0.2)
## works
val <- 0.2
obs.var <- hmmBinom(size=1, prob=val)
## works 
l.obs.sub <- lapply(seq(0.1, 0.9, by=0.1), function(x) {
    ret <- hmmBinom(size=1, prob=1)
    ret$pars['prob']  <- x
    ret
})
## fails: "object 'x' not found"
#l.obs <- lapply(seq(0.1, 0.9, by=0.1), 
#    function(x) hmmBinom(size=1, prob=x)
#)

## Full example
sim.df <- with(pars,
    expand.grid(time=seq(0,tmax,by=5), subject=1:npair)
)

## initial conditions / observation model
config <- list(
    qmat <- rbind(
        c(0, pars$q),
        c(0, 0)
    ),
    hmod = list(
        S=hmmBinom(size=1, prob=0.2),
        I=hmmBinom(size=1, prob=0.8)
    )
)

dat <- with(config,
    simmulti.msm(sim.df, qmat, hmodel=hmod, drop.absorb=F)
)
