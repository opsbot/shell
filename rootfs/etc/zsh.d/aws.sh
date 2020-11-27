#!/usr/bin/env zsh

AWS_DATA_PATH=/localhost/.aws

# Install autocompletion rules
if which aws_completer >/dev/null
then
  autoload bashcompinit && bashcompinit
  complete -C "$(which aws_completer)" aws
fi

if [ ! -d "${AWS_DATA_PATH}" ]
then
  echo "* Initializing ${AWS_DATA_PATH}"
  mkdir -p "${AWS_DATA_PATH}"
fi

# `aws configure` does not respect ENVs
if [ ! -e "${HOME}/.aws" ]
then
  ln -s "${AWS_DATA_PATH}" "${HOME}/.aws"
fi

if [ ! -f "${AWS_DATA_PATH}/config" ]
then
  echo "* Initializing ${AWS_DATA_PATH}/config"
  # Required for AWS_PROFILE=default
  echo '[default]' > "${AWS_DATA_PATH}/config"
fi
