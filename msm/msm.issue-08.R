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
