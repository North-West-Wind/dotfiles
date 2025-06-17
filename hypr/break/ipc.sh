#!/usr/bin/env sh

output_json() {
	echo "{\"class\":\"$1\"}" | jq --unbuffered --compact-output
}

pipe=/tmp/take-a-break
if [[ ! -p $pipe ]]; then
	output_json pause
	exit 0
fi

defer_file=/tmp/take-a-break.deferred
toggle_file=/tmp/take-a-break.enabled
if [ "$#" -eq 0 ]; then
	sleep 0.05 # To guarantee exec after change for waybar
	if [[ ! -f $toggle_file ]]; then
		output_json resume
	elif [[ -f $defer_file ]]; then
		output_json defer
	else
		output_json pause
	fi
	exit 0
fi

output_and_pipe() {
	echo "$1" > $pipe
	output_json "$1"
}

case "$1" in
	"toggle")
		if [[ ! -f $toggle_file ]]; then
			touch $toggle_file
			output_and_pipe "pause"
		else
			rm -f $toggle_file
			rm -f $defer_file
			output_and_pipe "resume"
		fi
		;;
	"pause")
		touch $toggle_file
		output_and_pipe "pause"
		;;
	"resume")
		rm -f $toggle_file
		rm -f $defer_file
		output_and_pipe "resume"
		;;
	"defer")
		touch $toggle_file
		touch $defer_file
		output_and_pipe "defer"
		;;
	"exit")
		echo "exit" > $pipe
		;;
esac