#!/usr/bin/env sh

if [ "$1" = "window" ]; then
	niri msg action screenshot-window -d false
	exit
elif [ "$1" = "full" ]; then
	flameshot full -c
elif niri msg focused-output | grep -q "HDMI-A-1"; then
	# This is my diagonally top left monitor
	if [ "$1" = "screen" ]; then
		flameshot screen -c -n 1
	else
		flameshot gui -c &
		fspid=$!
		window_id=$(niri msg windows | grep -B 1 -E 'Title: "flameshot"' | head -n 1 | awk '{print substr($3, 1, length($3)-1)}')
		while [ -z "$window_id" ]; do
			window_id=$(niri msg windows | grep -B 1 -E 'Title: "flameshot"' | head -n 1 | awk '{print substr($3, 1, length($3)-1)}')
		done
		niri msg action move-window-to-monitor --id "$window_id" "HDMI-A-1"
		niri msg action fullscreen-window --id "$window_id"
	fi
else
	# This is my main monitor
	if [ "$1" = "screen" ]; then
		flameshot screen -c -n 0
	else
		flameshot gui -c
	fi
fi