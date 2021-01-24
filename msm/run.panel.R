pars <- list(
    nsubject = 100,
    q.i = 0.2,
    q.r = 0.05
)

## S, Ix2, R
.nstate <- 4

## time of infection, recovery
state <- with(pars, data.table(
    id = 1:nsubject,
    infect = rexp(nsubject, q.i),
    recover = rgamma(nsubject, shape=2, q.r/2)
))
state[, recover := infect+recover]

## regular observation schedule
obs.time = seq(from=0, to=max(state$recover)+5, by=5)
panel <- state[, by=id, j=list(
    time = obs.time,
    ## 0 = S, 1 = I, 3 = R
    state = (obs.time > infect) + (obs.time > recover),
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
    obs[state==0] <- fn.obs(state==0, size=1, prob=0.9)
    obs[state==1] <- fn.obs(state==1, size=2, prob=0.3)
    obs[state==2] <- fn.obs(state==2, size=1, prob=0.8)
    ## known starting condition
    obs[time==0] <- -1
})

