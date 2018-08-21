library(bookdown)

dest <- 'jss'
od <- setwd(dest)
system('rm _main.Rmd')

#bookdown::render_book(fn.in, "bookdown::pdf_document2")
#bookdown::render_book(fn.in, "bookdown::html_document2")
#bookdown::render_book(fn.in, "rticles::peerj_article")

.fn <- paste0(dest, '.Rmd')
bookdown::render_book(
    .fn, 
    sprintf('rticles::%s_article', dest)
)
setwd(od)
