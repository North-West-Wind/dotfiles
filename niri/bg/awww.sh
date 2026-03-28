#!/usr/bin/env sh

while ! pidof -q awww-daemon; do
	sleep 1
done

awww img -o HDMI-A-2 ~/.config/niri/bg/diagonal_br.png --transition-type none
awww img -o HDMI-A-1 ~/.config/niri/bg/diagonal_tl.png --transition-type none