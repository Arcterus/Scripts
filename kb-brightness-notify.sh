#!/bin/sh

CONTROL_FILE='/tmp/kb-brightness-control.nid'

if [ -e $CONTROL_FILE ]; then
	NID=`cat $CONTROL_FILE`
else
	NID=`notify-send "Keyboard Brightness" -t 500 -p`
	echo $NID > $CONTROL_FILE
fi

brightness=`$(dirname $0)/write_to_kb read`

case $1 in
	"up")
		brightness=`expr $brightness + 25`
		;;
	"down")
		brightness=`expr $brightness - 25`
		;;
	"set")
		brightness=$2
		;;
	*)
		echo "I don't know what you mean"
		exit 1
		;;
esac

if [ "$brightness" -lt 0 ]; then
	brightness=0
elif [ "$brightness" -gt 255 ]; then
	brightness=255
fi

`dirname $0`/write_to_kb write $brightness

visible_br=`echo "$brightness / 2.55" | bc`

NID=`notify-send "Keyboard Brightness" -r $NID -t 500 -i xfpm-keyboard-100 -h int:value:$visible_br -p`

echo $NID > $CONTROL_FILE

