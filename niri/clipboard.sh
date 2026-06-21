#!/usr/bin/env sh

cliphist list | anyrun -c ~/.config/anyrun/clipboard | cliphist decode | wl-copy