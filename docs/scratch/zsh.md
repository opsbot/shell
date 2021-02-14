# zsh

## control flow

&& run second command only if first succeeds
|| run second command only if first fails
; wait until first finishes
& background first task and run second

## cross shell prompt

```sh
## ~/myprompt.sh

# 'ZSH_VERSION' only defined in Zsh
# 'precmd' is a special function name known to Zsh

[ ${ZSH_VERSION} ] && precmd() { myprompt; }

# 'BASH_VERSION' only defined in Bash
# 'PROMPT_COMMAND' is a special environment variable name known to Bash

[ ${BASH_VERSION} ] && PROMPT_COMMAND=myprompt

# function called every time shell is about to draw prompt
myprompt() {
  if [ ${ZSH_VERSION} ]; then
    # Zsh prompt expansion syntax
    PS1='%{%F{red}%}%n%{%f%}@%{%F{red}%}%m %{%F{cyan}%}%~ %{%F{white}%}%# %{%f%}'
  elif [ ${BASH_VERSION} ]; then
    # Bash prompt expansion syntax
    PS1='\[\e[31m\]\u\[\e[0m\]@\[\e[31m\]\h \[\e[36m\]\w \[\e[37m\]\$ \[\e[0m\]'
  fi
}
```
