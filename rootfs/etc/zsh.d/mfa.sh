#!/usr/bin/env bash

export MFA_DATA_PATH="${MFA_DATA_PATH:-/localhost/.config/mfa}"

mfa() {
	profile="${1:-${AWS_MFA_PROFILE}}"
	file="${MFA_DATA_PATH}/${profile}.mfa"

	if [ -f "${file}" ]; then
		oathtool --base32 --totp "$(cat "${file}")"
	elif [ -z "${profile}" ]; then
		echo "No MFA profile defined" >&2
	else
		echo "No MFA profile for $profile" >&2
	fi
}
