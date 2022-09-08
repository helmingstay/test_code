## Minimal working template for publication-quality figures with knitr 

* Primary document: template.Rnw
* Dependencies: R and packages knitr, tinytex, and ggplot2

* Install R packages (in R):
    - ```install.packages(c('knitr', 'tinytex', 'ggplot2'))```
* Configure tinytex (in R, installs latex locally)
    - ```tinytex::install_tinytex()```
    - For tinytex config details see https://yihui.org/tinytex/

* Instructions to build document in R
    - ```source("0build.R")```
