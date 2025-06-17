#!/usr/bin/env sh

# Pipe creationg
pipe=/tmp/take-a-break
if [[ ! -p $pipe ]]; then
	mkfifo $pipe
fi

# Configuration
interval=3600 # 3600s = 1 hour

# Program state
next=$(($(date +%s) + $interval))
running=1
paused=0

echo "Next reminder: $(date -d@$next)"

# Exit trap
trap "running=0; rm -f $pipe" EXIT

# Loop
while [ $running -eq 1 ]; do
	# Read pipe
	if read -t 1 line <> $pipe; then
		case "$line" in
			"exit")
				running=0
				;;
			"pause")
				paused=1
				echo "Paused"
				;;
			"resume")
				paused=0
				echo "Resumed"
				echo "Next reminder: $(date -d@$next)"
				;;
		esac
		sleep 1
	fi

	# Paused just increase next timer
	if [ $paused -eq 1 ]; then
		next=$(($next + 1))
	fi

	# Play video when time's up
	if [ $(date +%s) -gt $next ]; then
		playerctl pause
		mpv --background=color \
				--background-color="#3f000000" \
				--osc=no --fullscreen --wayland-app-id="take-a-break" \
				~/.config/hypr/break/remind.mov
		next=$(($(date +%s) + $interval))
		echo "Next reminder: $(date -d@$next)"
	fi
done

rm -f $pipe