library(RProtoBuf)
aa <- matrix(1:30, ncol=3) 
bb <- new(P("Array.a2d", file='Array.proto'))
bb$dim1 <- dim(aa)[1]
bb$dim2 <- dim(aa)[2]
bb$add(field='payload', values=aa)

cat(as.character(bb))
