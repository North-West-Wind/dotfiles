#!/usr/bin/env sh

while ! pidof -q swww-daemon; do
	sleep 1
done

swww img ~/.config/niri/bg/nsmbu-sky.png --transition-type none