#!/bin/sh

CONTROL_FILE='/tmp/volume-control.nid'

if [ -e $CONTROL_FILE ]; then
	NID=`cat $CONTROL_FILE`
else
	NID=`notify-send "Volume" -t 500 -p`
	echo $NID > $CONTROL_FILE
fi

case $1 in
	"up")
		amixer -D pulse set Master 5%+
		;;
	"down")
		amixer -D pulse set Master 5%-
		;;
	"toggle")
		amixer set Master toggle
		;;
	"help")
		echo "Usage: $0 [command] [arguments...]"
		echo ""
		echo "Commands:"
		echo -e "\tup\t:\tincrease the volume"
		echo -e "\tdown\t:\tdecrease the volume"
		echo -e "\ttoggle\t:\ttoggle the volume on or off"
		echo -e "\thelp\t:\tthis help menu"
		exit
		;;
	*)
		echo "I don't know what you mean"
		exit 1
		;;
esac

muted=`amixer get Master | tail -n1 | sed -E 's/.*\[([a-z]+)\]/\1/'`
volume=`amixer get Master | tail -n1 | sed -E 's/.*\[([0-9]+)\%\].*/\1/'`

if [[ $muted == "off" ]]; then
	NID=`notify-send "Muted" -r $NID -t 1000 -i notification-audio-volume-muted -h int:value:$volume -p`
else
	volume_id=
	if [ "$volume" -gt 66 ]; then
		volume_id='notification-audio-volume-high'
	elif [ "$volume" -gt 33 ]; then
		volume_id='notification-audio-volume-medium'
	elif [ "$volume" -gt 0 ]; then
		volume_id='notification-audio-volume-low'
	else
		volume_id='notification-audio-volume-off'
	fi
	NID=`notify-send "Volume" -r $NID -t 500 -i $volume_id -h int:value:$volume -p`
fi

echo $NID > $CONTROL_FILE

