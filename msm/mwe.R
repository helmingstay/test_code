library(msm)
library(data.table)
set.seed(8)

## msm docs: 
# * obstrue=1 required for censor effects (add note to censor?)
# * censor.state list: length 1 fails without error

pars <- list(
    nsubject = 1e2,
    q.i = 0.05
)

## SI
.nstate <- 2

## time of infection, recovery
state <- with(pars, data.table(
    id = 1:nsubject,
    infect = rexp(nsubject, q.i)
))

## regular observation schedule
obs.time = seq(from=0, to=max(state$infect)+5, by=5)
panel <- state[, by=id, j=list(
    time = obs.time,
    ## 0 = S, 1 = I
    state = (obs.time > infect),
    ## stub
    obs = 0
)]

## helper function: observation conditioned on target state
fn.obs <- function(equals, size, prob) {
    n <- sum(equals)
    rnbinom(n, size=size, prob=prob)
}

## generate observations from state
panel <- within(panel, {
    obs[state==0] <- rnbinom(sum(state==0), size=1, prob=0.9)
    obs[state==1] <- rnbinom(sum(state==1), size=2, prob=0.3)
    ## known starting condition
    obs[time==0] <- -1
})

config <- list(
    ## init transition rate matrix
    qmat = matrix(byrow=T, nrow=.nstate, c(
        ## S-I
        ## fit very sensitive to init cond
        0, pars$q.i*1.2,
        0, 0
    )),
    ## observation model 
    hmod = list(
        S=hmmNBinom(disp=1, prob=0.9),
        I=hmmNBinom(disp=2, prob=0.3)
    )
)

result <- msm(data=panel,
    obs ~ time,
    subject=id,
    #obstrue=obstrue,
    censor = c(-1, -2),
    censor.states=list(c(2,2),c(2)),
    obstrue = ifelse(obs<0, 1, NA),
    #obstrue = ifelse(obs<0, 0, NA),
    est.initprobs=F,
    qmatrix=config$qmat,
    hmodel=config$hmod,
    fixedpars=F,
    control=list(trace=2)
    #control=list(REPORT=10)
)

pred <- merge(
    panel, 
    as.data.frame(viterbi.msm(result)),
    by.x=c('id', 'time'), by.y=c('subject', 'time')
)
