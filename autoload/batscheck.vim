let s:wrapper = fnamemodify(resolve(expand('<sfile>:p')), ':h:h') . "/bin/bashcheck-wrapper.sh"
for s:checker in ["sh", "bashate", "checkbashisms", "shellcheck"]
  if !exists("g:syntastic_sh_".s:prog."_exe_before")
    let "g:syntastic_sh_".s:checker."_exe_before" = s:wrapper
  endif
endfor
