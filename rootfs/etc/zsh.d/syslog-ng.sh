#!/usr/bin/env bash

if ! pidof syslog-ng >/dev/null; then
	syslog-ng -f /etc/syslog-ng.conf
fi
