#!/usr/bin/env sh

while ! pidof -q swww-daemon; do
	sleep 1
done

swww img -o HDMI-A-2 ~/.config/niri/bg/diagonal_br.png --transition-type none
swww img -o HDMI-A-1 ~/.config/niri/bg/diagonal_tl.png --transition-type none