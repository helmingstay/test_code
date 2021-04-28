config <- list(
    ## transition rate matrix
    qmat = matrix(byrow=T, nrow=.nstate, c(
        ## S-I
        0, 0.5, 0, 0,
        ## I-I, I-R
        0, 0, 0.1, 0,
        0, 0, 0, 0.1,
        0, 0, 0, 0
    )),
    # S, Ix2
    qcon=c(1,2,2),
    ## observation model 
    hmod = list(
        S=hmmNBinom(disp=1, prob=0.9),
        I1=hmmNBinom(disp=2, prob=0.3),
        I2=hmmNBinom(disp=2, prob=0.3),
        R=hmmNBinom(disp=1, prob=0.8)
    ),
    hcon=list(disp=c(1,2,2,3), prob=c(1,2,2,3))
    #hranges=list(prob=list(lower=c(0, 0, 0), upper=c(1,1,1))),
)

result <- msm(data=panel,
    obs ~ time,
    subject=id,
    #obstrue=obstrue,
    censor = c(-1),
    censor.states=c(1,1),
    est.initprobs=F,
    ## state transitions
    qmatrix=config$qmat,
    qconstraint=config$qcon,
    ## observation process
    hmodel=config$hmod,
    hconstraint=config$hcon,
    ## 8 total: qI, qR, 2x hmmS, 2x hmmI, 2x hmmR
    fixedpars=c(3:8)
)
