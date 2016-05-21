#!/usr/bin/env bash
type "$1" >/dev/null 2>&1 || exit

args=()
wrapped_files=()
original_files=()

cleanup() {
  local f
  for f in "${original_files[@]}"; do
    [[ -f "$f" ]] && rm -f "$f"
  done
}
trap cleanup HUP INT QUIT TERM

# filter contents
for arg in "$@"; do
  if [[ $arg == *.bats && -f $arg ]]; then
    temp=$(mktemp)
    [[ -f "$temp" ]] || exit 1
    wrapped_files+=("$temp")
    original_files+=("$arg")
    # convert @test to dummy function definition
    perl -pe's/^\@test\s.*\{/"at_test_$. () {"/e' <"$arg" >"$temp"
    arg=$temp
  fi
  args+=("$arg")
done

# revert filenames in output
revert_filenames() {
  local line
  while read -r line; do
    for _ in "${!wrapped_files[@]}"; do
      line=${line//"${wrapped_files[$_]}"/${original_files[$_]}}
    done
    printf "%s\n" "$line"
  done
}
exec 1> >(revert_filenames)
exec 2> >(revert_filenames >&2)

"${args[@]}"
