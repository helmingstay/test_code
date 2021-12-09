library(msm)
set.seed(8)

## SI model
pars <- within(list(), {
    npair = 50
    ## transition rate
    q.i = 0.05
    prob=list(S=0.2, I=0.8)
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

## regular observation schedule
obs.time = seq(from=0, to=pars$tmax, by=5)

## input to msm: test results conditioned on infection status
panel <- lapply(1:nrow(subjects), function(ii) {
    x <- subjects[ii,]
    ## subject state at time t
    ## F = S, T = I
    state = (obs.time > x$infect)
    ## observation process conditioned on state
    obs = rbinom(length(state), 1, 
        ifelse(state, pars$prob$I, pars$prob$S)
    )
    data.frame(id=x$id, group=x$group, time=obs.time, state=state, obs=obs)
})
panel <- do.call(rbind, panel)

## censoring: 
## group A starts in known state 1
panel <- within(panel, {
    obs[(group=='A' & time==0)] <- -1
    ## group B starts in unknown state, not observed
    obs[(group=='B' & time==0)] <- -2
})

## initial conditions / observation model
config <- list(
    qmat = matrix(byrow=T, nrow=length(pars$nstate), c(
        ## S-I
        0, pars$q.i*1.2,
        0, 0
    )),
    hmod = list(
        S=hmmBinom(size=1, prob=0.1),
        I=hmmBinom(size=1, prob=0.9)
    )
)

result <- msm(data=panel,
    obs ~ time, subject=id,
    censor = c(-1, -2),
    ## group A: start in state 1 
    ## group B: start in state 2
    censor.states=list(c(1),c(2)),
    ## censored values indicate state
    obstrue=ifelse(obs<0, 1, NA),
    qmatrix=config$qmat,
    hmodel=config$hmod,
    fixedpars=T,
)

pred <- merge(
    panel, 
    as.data.frame(viterbi.msm(result)),
    by.x=c('id', 'time'), by.y=c('subject', 'time')
)

## I expect these individuals to be in state 2
subset(pred, group=='B' & time==0)
