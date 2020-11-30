#!/usr/bin/env bash

# Directory listings
# LS_COLORS='no=01;37:fi=01;37:di=07;96:ln=01;36:pi=01;32:so=01;35:do=01;35:bd=01;33:cd=01;33:ex=01;31:mi=00;05;37:or=00;05;37:'
# -h	Human readable sizes (1K 243M 2G)
# -p	Append / to dir entries
# -l	Long listing format
# --color[={always,never,auto}]	Control coloring
alias ls='ls -a -h -p --color=always '
alias ll='ls -a -h -p -l --color=always '

# Reload the shell (i.e. invoke as a login shell)
alias reload='exec zsh --login '
