#!/usr/bin/bash

source ~/.config/niri/hko/env.sh

finish=0
trap 'finish=1' SIGINT
trap 'finish=1' SIGQUIT
trap 'finish=1' SIGTSTP

hko_dir=/tmp/hko
mkdir -p $hko_dir

getdata() {
	# cleanup
	rm -f $hko_dir/warning_*.png
	rm -f $hko_dir/weather_info.txt

	# weather text
	weather_data=$(curl -s "https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=rhrread")
	temperature=$(echo "$weather_data" | jq -r ".temperature.data[] | select(.place == \"$HKO_TEMPERATURE_PLACE\")")
	if [ -n "$temperature" ]; then
		echo "$temperature" | jq -jr '.value' >> $hko_dir/weather_info.txt
		echo "°C" >> $hko_dir/weather_info.txt
	else
		echo "" >> $hko_dir/weather_info.txt
	fi
	echo "$weather_data" | jq -jr '.humidity.data[0].value' >> $hko_dir/weather_info.txt
	echo "%" >> $hko_dir/weather_info.txt
	rainfall=$(echo "$weather_data" | jq -r ".rainfall.data[] | select(.place == \"$HKO_RAINFALL_PLACE\")")
	if [ -n "$rainfall" ]; then
		echo "$rainfall" | jq -jr '.max' >> $hko_dir/weather_info.txt
		echo "mm" >> $hko_dir/weather_info.txt
	else 
		echo "" >> $hko_dir/weather_info.txt
	fi

	# weather icon
	icon=$(echo $weather_data | jq -r '.icon[0]')
	icon_url="https://www.hko.gov.hk/images/HKOWxIconOutline/pic$icon.png"
	curl -o "$hko_dir/current_weather.png" "$icon_url"

	# weather warning icon
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
		magick montage $hko_dir/warning_*.png -tile 3x4 -geometry 80x80+8+8 -shadow -background none "$hko_dir/warnings.png"
	fi
}

while (( $finish != 1 ))
do
	getdata
	sleep 600
done
