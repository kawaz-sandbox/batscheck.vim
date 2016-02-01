au BufRead,BufNewFile *.bats let b:shell = fnamemodify(resolve(expand('<sfile>:p')), ':h:h') . "/bin/batscheck"
