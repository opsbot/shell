#!/usr/bin/env bash

if [ -z "${ASSUME_ROLE}" ]; then
  # show motd from /etc/motd
  # IMPORTANT:
  # * Your $HOME directory has been mounted to `/localhost`
  # * Use `aws-vault` to manage your sessions
  # * Run `assume-role` to start a session
	if [ -f "/etc/motd" ]; then
		cat "/etc/motd"
	fi

  # fetch motd sub links frm web service
  # | Documentation  | https://docs.cloudposse.com   | Check out documention              |
  # | Public Slack   | https://slack.cloudposse.com  | Active & friendly DevOps community |
  # | Paid Support   | hello@cloudposse.com          | Get help fast from the experts     |
	if [ -n "${MOTD_URL}" ]; then
		curl --fail --connect-timeout 1 --max-time 1 --silent "http://geodesic.sh/motd"
	fi
fi
