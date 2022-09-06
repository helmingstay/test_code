library(ggplot2)

## set default theme, font size
## use paren to define extent of expression
gg.theme <- (
    theme_bw(base_size=12)
    + theme(
        panel.grid.minor=element_blank(),
        legend.background=element_blank(),
    )
)

## helper theme
gg.xlab.rot <- theme(axis.text.x=element_text(angle=90, hjust=1))

## helper function: latex tables
my.kable <- function(x, format='latex', digits=1, escape=F, ...) {
    kable(x, format=format, booktabs=T, linesep="", escape=escape, digits=digits, ...)
}

## see ?diamonds for details 
p.cut <- (
    ggplot(diamonds)
    + aes(y=cut, x=price)
    + geom_boxplot()
    + scale_x_log10()
    + gg.theme
)

## modify above figure
p.cut.color <- p.cut + facet_grid(~color)

## sample frequency, percent
tab.color <- as.data.frame(
    xtabs(~color, data=diamonds)
)
tab.color <- within(tab.color,
    Percent <- 100*Freq/sum(Freq)
)

## xtabs returns wide form by default
tab.color.cut <- xtabs(~color+cut, data=diamonds)
