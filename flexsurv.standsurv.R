## https://github.com/chjackson/flexsurv/issues/195

data(bc)
set.seed(236236)
## Age at diagnosis is correlated with survival time. A longer survival time 
## gives a younger mean age
bc$age <- rnorm(dim(bc)[1], mean = 65 - scale(bc$recyrs, scale=F), sd = 5)
## Create age at diagnosis in days - used later for matching to expected rates
bc$agedays <- floor(bc$age * 365.25)
## Create some random diagnosis dates between 01/01/1984 and 31/12/1989
bc$diag <- as.Date(floor(runif(dim(bc)[1], as.Date("01/01/1984", "%d/%m/%Y"), 
                               as.Date("31/12/1989", "%d/%m/%Y"))), 
                   origin="1970-01-01")
## Create sex (assume all are female)
bc$sex <- factor("female")
## 2-level prognostic variable
bc$group2 <- ifelse(bc$group=="Good", "Good", "Medium/Poor")

mod <- flexsurvreg(
    Surv(recyrs, censrec)~group2, 
    #anc = list(shape = ~ group2), dist="weibullPH"
    dist="weibull", data=bc
)

.at <- list(list(group2='Good'), list(group2='Medium/Poor'))
mod.contr <- standsurv(mod, 
        at=.at, 
        #contrast='difference', 
        B=1e4, boot=T, seed=7,
        t=20, cl=0.99, ci=T 
)

## error:
# Calculating bootstrap standard errors / confidence intervals
#Error in `rename()`:
#! Can't rename columns that don't exist.
#✖ Column `2.5%` doesn't exist.
