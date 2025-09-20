#!/usr/bin/bash

finish=0
trap 'finish=1' SIGINT
trap 'finish=1' SIGQUIT
trap 'finish=1' SIGTSTP

hko_dir=/tmp/hko
mkdir -p $hko_dir

getdata() {
	# cleanup
	rm -f $hko_dir/warning_*.png

	icon=$(curl -s "https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=rhrread" | jq -r '.icon[0]')
	icon_url="https://www.hko.gov.hk/images/HKOWxIconOutline/pic$icon.png"
	curl -o "$hko_dir/current_weather.png" "$icon_url"

	count=0
	warnings=$(curl -s "https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=warnsum" | jq -r '.[].code' | sort)
	for warning in ${warnings}
	do
		url=$(awk -v warn="$warning" -F',' '{ if ($1 == warn) { print $2 } }' ~/.config/niri/hko/warnings.csv)
		if [ -n "$url" ]; then
			curl -o "$hko_dir/warning_$count.png" "$url"
			((count++))
		fi
	done

	if (( $count == 0 )); then
		magick -size 50x50 xc:transparent "$hko_dir/warnings.png"
		rm -f "$hko_dir/blank.png"
	else
		magick montage $hko_dir/warning_*.png -tile 3x4 -geometry 100x100+10+10 -shadow -background none "$hko_dir/warnings.png"
	fi
}

getdata
#while (( $finish != 1 ))
#do
#	getdata
#	sleep 600
#done
