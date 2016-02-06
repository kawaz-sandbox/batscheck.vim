let s:save_cpo = &cpo
set cpo&vim

let s:wrapper = fnamemodify(resolve(expand('<sfile>:p')), ':h:h') . "/bin/batscheck-wrapper.sh"

function! batscheck#init()
  if (exists('b:batscheck_applied') && b:batscheck_applied)
    return
  endif
  let b:batscheck_applied = 1
  " shellcheck memo
  " SC1008: This shebang was unrecognized. Note that ShellCheck only handles sh/bash/ksh.
  " SC1091: Not following: <path/to/external>: openFile: does not exist (No such file or directory)
  for checker in [
        \ {"name":"sh", "args":""},
        \ {"name":"bashate", "args":""},
        \ {"name":"checkbashisms", "args":""},
        \ {"name":"shellcheck", "args":"-e SC1008,SC1091"}
        \ ]
    " echo checker
    " replace checker_exec to wrapper
    if exists("g:syntastic_sh_".checker.name."_exec")
      let checker_exec = g:syntastic_sh_{checker.name}_exec
    else
      if checker.name == "sh"
        if !exists("b:shell")
          let b:shell = "bash"
        endif
        let checker_exec = b:shell
      else
        let checker_exec = checker.name
      endif
    endif
    " let b:syntastic_sh_{checker.name}_exe = s:wrapper
    let b:syntastic_sh_{checker.name}_exec = s:wrapper
    " Insert original checker to checker_args
    let b:syntastic_sh_{checker.name}_args = checker_exec
    if exists("g:syntastic_sh_".checker.name."_args")
      let b:syntastic_sh_{checker.name}_args .= " ".g:syntastic_sh_{checker.name}_args
    endif
    if checker.args != ""
      let b:syntastic_sh_{checker.name}_args .= " ".checker.args
    endif
  endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
