library(msm)
library(data.table)
set.seed(8)

## msm docs: 
# * obstrue=1 required for censor effects (add note to censor?)
# * censor.state list: length 1 fails without error

## SI model
pars <- within(list(), {
    npair = 50
    q.i = 0.05
    prob=list(S=0.2, I=0.8)
    nstate=length(prob)
    tmax=20
})


subjects <- expand.grid(
    pair = 1:pars$npair,
    group = factor(c('A','B'))
)

## simulate time to infection
subjects <- within(subjects, {
    id <- paste(pair, group, sep='.')
    infect <- rexp(nrow(subjects), pars$q.i)
})
subjects <- data.table(subjects)

## regular observation schedule
obs.time = seq(from=0, to=pars$tmax, by=5)
#obs.time = seq(from=0, to=max(subjects$infect)+10, by=5)

## input to msm: test results conditioned on infection status
panel <- subjects[, by=.(id, group), j={
    time = obs.time
    ## F = S, T = I
    state = (obs.time > infect)
    ## observation process conditioned on state
    obs = rbinom(length(state), 1, 
        ifelse(state, pars$prob$I, pars$prob$S)
    )
    .(time, state, obs)
}]

## censoring: 
## group A starts in known state 1
panel[(group=='A' & time==0)]$obs <- -1
## group B starts in unknown state
panel[(group=='B' & time==0)]$obs <- -2
## Both have unknown observattion 
panel[(time==10)]$obs <- -2

## initial conditions
config <- list(
    qmat = matrix(byrow=T, nrow=.nstate, c(
        ## S-I
        0, pars$q.i*1.2,
        0, 0
    )),
    ## observation model 
    ## eval issue in hmmDIST
    #hmod = with(pars$prob, list(
        #S=hmmBinom(size=1, prob=S-0.1),
        #I=hmmBinom(size=1, prob=I+0.1)
    #))
    hmod = list(
        S=hmmBinom(size=1, prob=0.1),
        I=hmmBinom(size=1, prob=0.9)
    )
)

result <- msm(data=panel,
    obs ~ time,
    subject=id,
    censor = c(-1, -2),
    ## Informative group-A init 
    ## works as intended
    censor.states=list(c(1,1),c(1,2)),
    ##? behavior differs from above
    # censor.states=list(c(1),c(1,2)),
    ##? how does this work?
    # obstrue = ifelse(obs<0, 1, NA),
    ## initprobs are ignored?
    initprobs=c(0.9, 0.1),
    ##? AIC changes, but no difference in pstate
    #initprobs=c(0.1, 0.9),
    qmatrix=config$qmat,
    hmodel=config$hmod,
    fixedpars=T,
)

pred <- merge(
    panel, 
    as.data.frame(viterbi.msm(result)),
    by.x=c('id', 'time'), by.y=c('subject', 'time')
)
