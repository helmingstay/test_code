#!/bin/sh
DIR=mwe-knitr
rm $DIR/template.log
rm $DIR/template.tex
rm $DIR/template.pdf
tar --exclude=figure --exclude=.Rhistory -czvf knitr-example.tar.gz $DIR
