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
