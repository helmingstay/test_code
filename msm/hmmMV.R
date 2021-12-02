nsubj <- 30; nobspt <- 5
sim.df <- data.frame(subject = rep(1:nsubj, each=nobspt),
                  time = seq(0, 20, length=nobspt))
set.seed(1)
two.q <- rbind(c(-0.1, 0.1), c(0, 0))
dat <- simmulti.msm(sim.df[,1:2], qmatrix=two.q, drop.absorb=FALSE)

dat$obs1 <- dat$obs2 <- NA
dat$obs1[dat$state==1] <- rbinom(sum(dat$state==1), 40, 0.1)
dat$obs2[dat$state==1] <- rbinom(sum(dat$state==1), 40, 0.2)

## Bin(40, 0.5) and Bin(40, 0.6) for state 2
dat$obs1[dat$state==2] <- rbinom(sum(dat$state==2), 40, 0.6)
dat$obs2[dat$state==2] <- rbinom(sum(dat$state==2), 40, 0.5)
#dat$obs <- cbind(obs1 = dat$obs1, obs2 = dat$obs2)

## AIC 759.8598
ret <- msm(obs1 ~ time, subject=subject, data=dat, qmatrix=two.q,
    hmodel = list(
        hmmBinom(size=40, prob=0.3), 
        hmmBinom(size=40, prob=0.3)
    ),
    control=list(maxit=10000)
)

## master: AIC 1489.642
ret1 <- msm(cbind(obs1, obs2) ~ time, subject=subject, data=dat, qmatrix=two.q,
    hmodel = list(
        hmmMV(hmmBinom(size=40, prob=0.3), hmmBinom(size=40, prob=0.3)),
        hmmMV(hmmBinom(size=40, prob=0.3), hmmBinom(size=40, prob=0.3))
    ),
    control=list(maxit=10000)
)


dat2 <- dat
dat2[(dat2$time==0), 'obs1'] <- 100
dat2[(dat2$time==0), 'obs2'] <- 100

## AIC 719.6242
ret2 <- msm(obs1 ~ time, subject=subject, data=dat2, qmatrix=two.q,
    censor = 100,
    censor.states=c(1,2),
    hmodel = list(
        hmmBinom(size=40, prob=0.3),    
        hmmBinom(size=40, prob=0.3)
    ),
    control=list(maxit=10000)
)

if(T) {
ret3 <- msm(cbind(obs1, obs2) ~ time, subject=subject, data=dat2, qmatrix=two.q,
    censor = 100,
    censor.states=c(1,2),
    hmodel = list(
        hmmMV(hmmBinom(size=40, prob=0.3), hmmBinom(size=40, prob=0.3)),
        hmmMV(hmmBinom(size=40, prob=0.3), hmmBinom(size=40, prob=0.3))
    ),
    control=list(maxit=10000)
)
}
