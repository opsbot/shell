#!/usr/bin/env zsh

#
# Z Shell Startup File
#

# `.zshrc' is sourced in interactive shells.
# It should contain commands to set up aliases, functions, options, key bindings, etc.

##############################################################################
# ===== Basic options
##############################################################################
# If you type foo, and it isn't a command, and it is a directory in your cdpath, go there
setopt AUTO_CD

# Allow comments even in interactive shells (especially for Muness)
# setopt INTERACTIVE_COMMENTS

##############################################################################
# Z Shell Keybindings Configuration
##############################################################################

# To see the key combo you want to use just do:
# cat > /dev/null
# And press it

# bindkey -v   # Default to standard vim bindings

# bindkey "^W"      kill-whole-line                      # ctrl-k
# bindkey "^R"      history-incremental-search-backward  # ctrl-r
# bindkey "^S"      history-incremental-search-forward   # ctrl-s
# bindkey "^A"      beginning-of-line                    # ctrl-a
# bindkey "^E"      end-of-line                          # ctrl-e
# bindkey "^N"      history-search-forward               # ctrl-n
# bindkey "^P"      history-search-backward              # ctrl-p
# bindkey "^D"      delete-char                          # ctrl-d
# bindkey "^F"      forward-char                         # ctrl-f
# bindkey "^B"      backward-char                        # ctrl-b

##############################################################################
# Z Shell Colors Configuration
##############################################################################

autoload colors && colors

##############################################################################
# Z Shell Autocomplete Configuration
##############################################################################

# Allow completion from within a word/phrase
setopt COMPLETE_IN_WORD

# When completing from the middle of a word, move the cursor to the end of the word
setopt ALWAYS_TO_END

ZCOMPDUMPFILE="$ZDOTCACHEDIR/.zcompdump-$ZSH_VERSION"
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d "$ZCOMPDUMPFILE" -C
_comp_options+=(globdots) # Include hidden files.

##############################################################################
# Z Shell History Configuration
##############################################################################

HISTDUP=erase                         # Erase duplicates in the history file
HISTFILE="$ZDOTCACHEDIR/.zsh_history" # History file location
HISTSIZE=1000                         # How many lines of history to keep in memory
SAVEHIST=1000                         # Number of history entries to save to disk

# Allow multiple terminal sessions to all append to one zsh command history
setopt APPEND_HISTORY

# Add comamnds as they are typed, don't wait until shell exit
setopt INC_APPEND_HISTORY

# Do not write events to history that are duplicates of previous events
setopt HIST_IGNORE_DUPS

# When searching history don't display results already cycled through twice
setopt HIST_FIND_NO_DUPS

# Remove extra blanks from each command line being added to history
setopt HIST_REDUCE_BLANKS

# Include more information about when the command was executed, etc
setopt EXTENDED_HISTORY

##############################################################################
# Z Shell Plugins Configuration
##############################################################################
# https://github.com/unixorn/awesome-zsh-plugins#antibody
source <(antibody init)

while IFS= read -r line
do
  antibody bundle "$line"
done <<< $(grep -v '^#' /etc/zsh/plugins.txt)

# load local condifuration stored in /etc/zsh.d
for i in /etc/zsh.d/*; do
  source $i
done
