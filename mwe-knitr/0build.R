## assumes tinytex install
## see https://yihui.org/tinytex/
library(knitr)
library(tinytex)
knit('template.Rnw')
## use clean=F for .aux file (sometimes helpful for figure cross-references)
tinytex::pdflatex('template.tex', clean=T)
