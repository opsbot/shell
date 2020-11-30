#!/usr/bin/env bash

################################################################################
# TUI Functions
################################################################################

banner() {
  if [ -n "${PS1:-}" ]; then
    TERM=linux clear
  fi
  (>&2 echo -e "$(green "${BANNER}")")
}

action() {
  msg="${1:-}"
  (>&2 echo -e "$(yellow "[action]:\n") ${msg} ...")
}

bot() {
  msg="${1:-}"
  (>&2 echo -e "$(green "\[._.]/") - ${msg}")
}

bot_confirm() {
  msg="${1:-}"
  (>&2 echo -e "$(green "\[._.]/") - ${msg}")
  info "Press any key to continue."
  # shellcheck disable=SC2162
  read
}

die() {
  (>&2 echo "$@")
  exit 1
}

error() {
  msg="${1:-}"
  (>&2 echo -e "$(red "[error]") ${msg}")
}

info() {
  msg="${1:-}"
  (>&2 echo -e "$(green "[info]") ${msg}")
}

line() {
  (>&2 echo -e "------------------------------------------------------------------------------------")
}

ok() {
  msg="${1:-}"
  (>&2 echo -e "$(green "[ok]") ${msg}")
}

running() {
  msg="${1:-}"
  (>&2 echo -e "$(yellow "⇒") ${msg}:")
}

warn() {
  msg="${1:-}"
  (>&2 echo -e "$(green "[warning]") ${msg}")
}

wait_user_confirm() {
  read -n1 -rsp $'Press Y continue or Ctrl+C to exit...\n' key
  if [ "$key" = 'Y' ]; then
    echo '' # Y pressed, continue
  else
    wait_user_confirm # Anything else pressed, repeat prompt
  fi
}
