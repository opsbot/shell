#!/usr/bin/env bash

# https://github.com/direnv/direnv/wiki/Misc-utils

# Example usage:

# $ check_env HOME FOO BAR
# FOO is missing
# BAR is missing
# $ echo $?
# 1

check_env() {
  local ret=0
  for var in "$@"
  do
    [[ -v $var ]] || { echo "$var is missing"; ret=1; }
  done
  return $ret
}
