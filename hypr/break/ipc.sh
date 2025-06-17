#!/usr/bin/env sh

pipe=/tmp/take-a-break
if [[ ! -p $pipe ]]; then
	echo "Take-a-break is not running"
	exit 1
fi

if [[ "$1" ]]; then
	echo "$1" > $pipe
fi