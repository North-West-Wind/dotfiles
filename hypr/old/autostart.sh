#!/bin/sh
/usr/bin/discord --in-process-gpu &
easyeffects --gapplication-service &
/usr/bin/element-desktop --hidden &
firejail --profile=no-libwnck /opt/soundux/soundux --hidden &
