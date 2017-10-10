#!/bin/bash

function error() {
	if [[ -t 1 ]]; then
		printf "\e[1;31m$*\e[0m\n" >&2
	else
		printf "$*\n" >&2
	fi
}

function usage() {
	error "Usage: noisy SLEEP_TIME [LOG_MESSAGE]"
	error '  SLEEP_TIME: Number of seconds to wait between logs. Default is 5 seconds.'
	error '  LOG_MESSAGE: The message to print every SLEEP_TIME seconds. Use `{{time}}` in the string for current time. Default is a JSON log.'
}

function stamp() {
	date '+%Y-%m-%d %H:%M:%S'
}

sleep_time=${1:-5}
log_message=${@:2}

if [[ -z "$log_message" ]]; then
	log_message='{"time": "{{time}}", "key": "value", "number": 123.456, "bool": true}'
fi

if [[ -z "$sleep_time" || -z "$log_message" ]]; then
	usage
	exit 2
fi

if [[ ! "$sleep_time" =~ ^[0-9]+(\.[0-9]*)?$ ]]; then
	error "Sleep time must be an integer: $sleep_time"
	usage
	exit 2
fi

while [[ $? == 0 ]]; do
	time=$(stamp)
	echo "${log_message/\{\{time\}\}/$time}"
	sleep "$sleep_time"
done
