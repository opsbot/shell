#!/usr/bin/env bash

# Use `man` page system for help
help() {
	if [ $# -ne 0 ]; then
		docs search --query="$*"
	else
		docs search
	fi
}
