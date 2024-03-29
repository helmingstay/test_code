library(msm)
set.seed(8)

pars <- within(list(), {
    npair = 20
    ## transition rate
    q = 0.05
    prob=list(S=0.2, I=0.8)
    deltat=5
    tmax=20
})

## Full example
sim.grid <- with(pars,
    expand.grid(time=seq(0,tmax,by=deltat), subject=1:npair)
)

## initial conditions / observation model
config <- list(
    qmat = rbind(
        c(0, pars$q),
        c(0, 0)
    ),
    hmod = list(
        S=hmmBinom(size=1, prob=0.2),
        I=hmmBinom(size=1, prob=0.8)
    )
)

sim.dat <- simmulti.msm(sim.grid, 
    config$qmat, drop.absorb=F,
    hmodel=list(
        S=hmmBinom(size=1, prob=0.2),
        ## sim uses larger size
        I=hmmBinom(size=2, prob=0.8)
    )
)

panel <- subset(sim.dat, select=c(subject, time, obs))
panel <- within(panel, {
    ## force state 2
    obstrue <- ifelse(obs==2, 2, NA)
    obs <- ifelse(obs>1, 1, 0)
})

result <- msm(data=panel,
    obs ~ time, subject=subject,
    obstrue=obstrue,
    qmatrix=config$qmat,
    hmodel=config$hmod,
    fixedpars=T
)

pred <- merge(
    panel,
    viterbi.msm(result),
    by=c('subject', 'time'), sort=F
)

## I expect pstate.2==1 when obstrue==2 
expect <- subset(pred, obstrue==2)
