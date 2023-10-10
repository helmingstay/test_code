## gam predictions with emmeans
## see https://stats.stackexchange.com/questions/471267/plotting-gams-on-response-scale-with-multiple-smooth-and-linear-terms/628412#628412

library("mgcv")
library("ggplot2")
library("emmeans")

set.seed(1)
df <- gamSim()
m <- gam(y ~ s(x0) + s(x1) + s(x2) + s(x3), data = df, method = "REML")

at.list = with(df, list(
    x2=seq(min(x2), max(x2), length = 200),
     x0 = median(x0),
     x1 = median(x1),
     x3 = median(x3)
))

new_data <- with(at.list, data.frame(
    x0, x1, x2, x3
))

quant <- qnorm(1-0.05/2)
ilink <- family(m)$linkinv
pred <- predict(m, new_data, type = "link", se.fit = TRUE)
pred <- cbind(pred, new_data)
pred <- transform(pred, lwr_ci = ilink(fit - (quant * se.fit)),
                        upr_ci = ilink(fit + (quant * se.fit)),
                        fitted = ilink(fit))

pred.emm <- as.data.frame(emmeans(m, ~x2, at=at.list, adjust='none', level=0.95))

p1 <- (
    ggplot(pred.emm, aes(x = x2, y = emmean))
    + geom_ribbon(aes(ymin = lower.CL, ymax = upper.CL), alpha = 0.2)
    + geom_line()
)

## compare CI between methods
head(cbind( 
    pred[, c('lwr_ci', 'upr_ci')], 
    pred.emm[, c('lower.CL', 'upper.CL')]
))
