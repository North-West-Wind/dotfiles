#!/usr/bin/env sh 

source=$1
finish=0

trap 'finish=1' SIGINT
trap 'finish=1' SIGQUIT
trap 'finish=1' SIGTSTP

pactllog=$(mktemp)
script -q -c "pactl subscribe" > $pactllog &
pactlpid=$!

while (( $finish != 1 ))
do
	first=1
	mute=$(pactl get-source-mute "$source" | cut -c 7-)
	if [ "$mute" = "no" ]; then
		echo "{\"text\":\"$source\",\"class\":\"unmute\"}"
	else
		echo "{\"text\":\"$source\",\"class\":\"mute\"}"
	fi
	tail -f -n0 $pactllog | grep -qe "change"
done

rm $pactllog
