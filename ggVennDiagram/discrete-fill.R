#library(RVenn)
library(ggplot2)
library(ggVennDiagram)
library(wrapr)

genes <- paste("gene",1:1000,sep="")
set.seed(20210419)
x <- list(A=sample(genes,300),
          B=sample(genes,525),
          C=sample(genes,440),
          D=sample(genes,350))
x.plot <- ggVennDiagram(x, label='count') 
x.process <- process_data(Venn(x))
count.thresh <- 50
fill.color <- c('transparent', 'grey50')

works.base <- (
    x.plot 
    + scale_fill_gradient(low=fill.color[1], high=fill.color[2])
)

## from example in https://github.com/gaospecial/ggVennDiagram
test <- (
    ggplot()
    + geom_sf(aes(color=name), linewidth=1.5, data = venn_region(x.process), show.legend=F)
    #+ geom_sf(aes(fill=(count>=count.thresh), color=name), linewidth=1.5, data = venn_region(x.process), show.legend=F)
    #+ scale_fill_manual(values=fill.color)
    + geom_sf_label(aes(label=id), fontface = "bold", data = subset(venn_region(x.process), count>count.thresh))
    + geom_sf_text(aes(label = name), data = venn_setlabel(x.process))
    + theme_void()
)
