library(rticles)
rmarkdown::draft('springer.Rmd', template = "springer_article", package = "rticles")
rmarkdown::draft('in.Rmd', template = "plos_article", package = "rticles")
## Old pandoc
## --latex-engine has been removed.  Use --pdf-engine instead.
rmarkdown::draft('rsos.Rmd', template = "rsos_article", package = "rticles")
rmarkdown::draft('jss.Rmd', template = "jss_article", package = "rticles")
