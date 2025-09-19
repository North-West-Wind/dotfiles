#!/usr/bin/bash

finish=0
trap 'finish=1' SIGINT
trap 'finish=1' SIGQUIT
trap 'finish=1' SIGTSTP

hko_dir=/tmp/hko
mkdir -p $hko_dir

makeshadow() {
	magick "$hko_dir/warnings.png" -alpha Opaque +level-colors black -channel A -evaluate set 25% +channel "$hko_dir/blank.png"
}

getdata() {
	icon=$(curl -s "https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=rhrread" | jq -r '.icon[0]')
	icon_url="https://www.hko.gov.hk/images/HKOWxIconOutline/pic$icon.png"
	curl -o "$hko_dir/current_weather.png" "$icon_url"

	count=0
	args=()
	warnings=$(curl -s "https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=warningInfo" | jq -r '.details.[].subtype')
	for warning in "${warnings[@]}"
	do
		lower=$(echo "$warning" | tr '[:upper:]' '[:lower:]')
		curl -o "$hko_dir/warning_$count.gif" "https://www.hko.gov.hk/en/wxinfo/dailywx/images/$lower.gif"
		args+=" $hko_dir/warning_$count.png"
		((count++))
	done

	if (( ${#args[@]} == 0 )); then
		magick -size 50x50 xc:transparent "$hko_dir/warnings.png"
		rm -f "$hko_dir/blank.png"
	elif (( ${#args[@]} == 1 )); then
		magick "$hko_dir/warning_0.gif" "PNG24:$hko_dir/warnings.png"
		makeshadow
	else
		magick "${args[@]}" +append "$hko_dir/warnings.png"
		makeshadow
	fi
}

while (( $finish != 1 ))
do
	getdata
	sleep 600
done
