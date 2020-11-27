#!/usr/bin/env zsh

#
# Z Shell Startup File
#

# `.zshenv' is sourced on all invocations of the shell, unless the -f option is set.
# It should contain commands to set the command search path, plus other important environment variables.
# `.zshenv' should not contain commands that produce output or assume the shell is attached to a tty.

# There are five startup files that zsh will read commands from: (in load order)

# $ZDOTDIR/.zshenv
# $ZDOTDIR/.zprofile
# $ZDOTDIR/.zshrc
# $ZDOTDIR/.zlogin
# $ZDOTDIR/.zlogout


export GEODESIC_SHELL=true

# place XDG_CACHE on localhost volume for persistence
export XDG_CACHE_HOME=/localhost/.cache/opsbot
# place XDG_DATA on localhost volume for persistence
export XDG_DATA_HOME=/localhost/.data/opsbot

export ZDOTCACHEDIR="${XDG_CACHE_HOME}/zsh"

# ensure $ZDOTCACHEDIR directory exists
[ ! -d "$ZDOTCACHEDIR" ] && mkdir -p "$ZDOTCACHEDIR"

# If ZDOTDIR is not set, then the value of HOME is used.
# this var is set in Dockerfile
# export ZDOTDIR="/etc/zsh"
