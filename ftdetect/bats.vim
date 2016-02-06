let s:wrapper = fnamemodify(resolve(expand('<sfile>:p')), ':h:h') . "/bin/bashcheck-wrapper.sh"

function! g:BatscheckAuForSyntastic()
  " wrap original checker
  for s:checker in ["sh", "bashate", "checkbashisms", "shellcheck"]
    let b:syntastic_sh_{s:checker}_exec_before = s:wrapper
  endfor
  " Add shellcheck options. This rules can not use with batswrapp.
  " SC1008: This shebang was unrecognized. Note that ShellCheck only handles sh/bash/ksh.
  " SC1091: Not following: <path/to/external>: openFile: does not exist (No such file or directory)
  let b:syntastic_sh_shellcheck_args_before = "-e SC1008,SC1091"
  if exists("g:syntastic_sh_shellcheck_args_before")
    let b:syntastic_sh_shellcheck_args_before .= " " . g:syntastic_sh_shellcheck_args_before
  endif
endfunction

au BufRead,BufNewFile *.bats call g:BatscheckAuForSyntastic()
