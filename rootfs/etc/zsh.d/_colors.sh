#!/usr/bin/env bash

# Files in the profile.d directory are executed by the lexicographical order of their file names.
# This file is named _colors.sh. The leading underscore is needed to ensure this file executes before
# other files that depend on the functions defined here. This file has no dependencies and should come first.

#
# Color Code for tput:
#
# 0 – Black
# 1 – Red
# 2 – Green
# 3 – Yellow
# 4 – Blue
# 5 – Magenta
# 6 – Cyan
# 7 – White

#
# tput Color Capabilities:
#

# tput setaf [1-7] – Set a foreground color using ANSI escape
# tput setf [1-7] – Set a foreground color

 red() {
	echo "$(tput setaf 1)$*$(tput sgr0)"
}

 green() {
	echo "$(tput setaf 2)$*$(tput sgr0)"
}

yellow() {
	echo "$(tput setaf 3)$*$(tput sgr0)"
}

blue() {
	echo "$(tput setaf 4)$*$(tput sgr0)"
}

magenta() {
	echo "$(tput setaf 5)$*$(tput sgr0)"
}

cyan() {
	echo "$(tput setaf 6)$*$(tput sgr0)"
}

white() {
	echo "$(tput setaf 7)$*$(tput sgr0)"
}

# tput setab [1-7] – Set a background color using ANSI escape
# tput setb [1-7] – Set a background color

bg_red() {
	echo "$(tput setab 1)$*$(tput sgr0)"
}

bg_green() {
	echo "$(tput setab 2)$*$(tput sgr0)"
}

bg_yellow() {
	echo "$(tput setab 3)$*$(tput sgr0)"
}

bg_blue() {
	echo "$(tput setab 4)$*$(tput sgr0)"
}

bg_magenta() {
	echo "$(tput setab 5)$*$(tput sgr0)"
}

bg_cyan() {
	echo "$(tput setab 6)$*$(tput sgr0)"
}

bg_white() {
	echo "$(tput setab 7)$*$(tput sgr0)"
}

#
# tput Text Mode Capabilities:
#

# tput bold – Set bold mode
bold() {
  echo "$(tput bold)$*$(tput sgr0)"
}

# tput dim – turn on half-bright mode
dim() {
  echo "$(tput dim)$*$(tput sgr0)"
}

# tput smul – begin underline mode
smul() {
  echo "$(tput smul)$*$(tput sgr0)"
}

# tput rev – Turn on reverse mode
rev() {
  echo "$(tput rev)$*$(tput sgr0)"
}

# tput smso – Enter standout mode (bold on rxvt)
# tput rmso – Exit standout mode
# tput sgr0 – Turn off all attributes
