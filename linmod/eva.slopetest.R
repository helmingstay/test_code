## definitions
.nn <- 1e3
.tx.effect <- c(A=2,B=4)
.tx <- names(.tx.effect)
.main.effect <- 1
set.seed(7)

## design grid
the.dat <- expand.grid(
    tx=.tx,
    index=1:.nn
)
.nobs <- nrow(the.dat)

## fill design grid with observations
the.dat <- within(the.dat, {
    pred <- runif(.nobs)
    noise <- rnorm(.nobs) 
    resp <- .main.effect + noise + pred * (1+.tx.effect[as.character(tx)])
})

mod.1 <- lm(resp ~ pred:tx, the.dat)
mod.2 <- lm(resp ~ pred + pred:tx, the.dat)
