#!/bin/sh

CONTROL_FILE='/tmp/brightness-control.nid'

if [ -e $CONTROL_FILE ]; then
	NID=`cat $CONTROL_FILE`
else
	NID=`notify-send "Brightness" -t 500 -p`
	echo $NID > $CONTROL_FILE
fi

case $1 in
	"up")
		xbacklight +10
		;;
	"down")
		xbacklight -10
		;;
	"set")
		xbacklight =$2
		;;
	*)
		echo "I don't know what you mean"
		exit 1
		;;
esac

brightness=`xbacklight -get`

NID=`notify-send "Brightness" -r $NID -t 500 -i xfpm-brightness-lcd -h int:value:$brightness -p`

echo $NID > $CONTROL_FILE

