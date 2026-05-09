library(httpgd)
library(purrr)
hgd()
cmd <- sprintf(
    'ssh -v -L 8080:127.0.0.1:%d carya',
    hgd_details()$port
)
url <- sprintf(
    'http://127.0.0.1:8080/live?token=%s',
    hgd_details()$token
)
cat(cmd, '\n')
cat(url, '\n')
