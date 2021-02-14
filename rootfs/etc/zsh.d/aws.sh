#!/usr/bin/env bash

export AWS_DATA_PATH=${AWS_DATA_PATH:-/localhost/.aws}

# create data path if not present
if [ ! -d "${AWS_DATA_PATH}" ]; then
  echo "* Initializing ${AWS_DATA_PATH}"
  mkdir -p "${AWS_DATA_PATH}"
fi

# `aws configure` does not respect ENVs
if [ ! -e "${HOME}/.aws" ]; then
  ln -s "${AWS_DATA_PATH}" "${HOME}/.aws"
fi

# initialize aws config file if not present
if [ ! -f "${AWS_DATA_PATH}/config" ]; then
  echo "* Initializing ${AWS_DATA_PATH}/config"
  # Required for AWS_PROFILE=default
  echo '[default]' > "${AWS_DATA_PATH}/config"
fi

# Install autocompletion rules
if which aws_completer >/dev/null; then
  autoload bashcompinit && bashcompinit
  complete -C "$(which aws_completer)" aws
fi

# Asks AWS what the currently active identity is and
# sets environment variables accordingly
function export_current_aws_role() {
	local role_name
	# Could be a primary or assumed role. If we have assumed a role, cut off the session name.
	local current_role=$(aws sts get-caller-identity --output text --query 'Arn' | cut -d/ -f1-2 2>/dev/null)
	if [[ -z $current_role ]]; then
		unset ASSUME_ROLE
		return 0
	fi

	# saml2aws will store the assumed role from sign-in as x_principal_arn in credentials file
	# Default values from https://awscli.amazonaws.com/v2/documentation/api/latest/topic/config-vars.html
	local creds_file="${AWS_SHARED_CREDENTIALS_FILE:-\~/.aws/credentials}"
	if [[ -r $creds_file ]]; then
		role_name=$(crudini --get --format=lines "${creds_file}" | grep "$current_role" | head -1 | cut -d' ' -f 2)
	fi

	# Assumed roles are normally found in AWS config file, but using the role ARN,
	# not the assumed role ARN. google2aws also puts login role in this file.
	local config_file="${AWS_CONFIG_FILE:-\~/.aws/config}"
	if [[ -z $role_name ]] && [[ -r $config_file ]]; then
		local role_arn=$(printf "%s" "$current_role" | sed 's/:sts:/:iam:/g' | sed 's,:assumed-role/,:role/,')
		role_name=$(crudini --get --format=lines "$config_file" | grep "$role_arn" | head -1 | cut -d' ' -f 3)
	fi

	if [[ -z $role_name ]]; then
		if [[ "$role_arn" =~ "role/OrganizationAccountAccessRole" ]]; then
			role_name="$(printf "%s" "$role_arn" | cut -d: -f 5):OrgAccess"
			echo "* $(red "Could not find profile name for ${role_arn}\; calling it \"${role_name}\"")" >&2
		else
			role_name="$(printf "%s" "$role_arn" | cut -d/ -f 2)"
			echo "* $(green "Could not find profile name for ${role_arn}\; calling it \"${role_name}\")" >&2
		fi
	fi
	export ASSUME_ROLE="$role_name"
}

# If okta or aws-vault are running, we have better hooks for keeping track of
# the current AWS role, so only use refresh_current_aws_role_if_needed if they are disabled
if [[ $AWS_OKTA_ENABLED != "true" ]] && [[ ${AWS_VAULT_ENABLED:-true} != "true" ]]; then
	PROMPT_HOOKS+=("refresh_current_aws_role_if_needed")
fi
