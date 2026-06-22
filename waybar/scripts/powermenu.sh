#!/usr/bin/env sh

lock='   Lock'
suspend='   Suspend'
logout='  Logout'
reboot='   Reboot'
shutdown='   Poweroff'

chosen=$(echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | anyrun -c ~/.config/anyrun/powermenu)

confirm() {
	chosen=$(echo -e "Yes, $1!\nNevermind" | anyrun -c ~/.config/anyrun/powermenu)
	if [ "$chosen" = "Yes, $1!" ]; then
		echo 0
	else
		echo 1
	fi
}

case ${chosen} in
	$shutdown)
		if [ $(confirm shutdown) -eq 0 ]; then systemctl poweroff; fi
		;;
	$reboot)
		if [ $(confirm reboot) -eq 0 ]; then systemctl reboot; fi
		;;
	$lock)
		loginctl lock-session
		;;
	$suspend)
		if [ $(confirm suspend) -eq 0 ]; then systemctl suspend; fi
		;;
	$logout)
		if [ $(confirm logout) -eq 0 ]; then niri msg action quit -s; fi
		;;
esac