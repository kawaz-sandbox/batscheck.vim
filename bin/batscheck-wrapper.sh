#!/bin/bash
args=()
wrapped=()
orginal=()

# shellcheck disable=SC2154
trap 'for f in "${original[@]}";do [[ -f "$f" ]] && rm -f "$f"; done' HUP INT QUIT TERM

# filter contents
for arg in "$@"; do
  if [[ $arg == *.bats && -f $arg ]]; then
    temp=$(mktemp)
    [[ -f "$temp" ]] || exit 1
    wrapped+=("$temp")
    original+=("$arg")
    # convert @test to dummy function definition
    perl -pe's/^\@test\s.*\{/"at_test_$. () {"/e' <"$arg" >"$temp"
    arg=$temp
  fi
  args+=("$arg")
done

# revert filenames in output
revert_filenames() {
  local line i
  while read -r line; do
    for i in "${!wrapped[@]}"; do
      line=${line//"${wrapped[$i]}"/${original[$i]}}
    done
    printf "%s\n" "$line"
  done
}
exec 1> >(revert_filenames)
exec 2> >(revert_filenames >&2)

"${args[@]}"
