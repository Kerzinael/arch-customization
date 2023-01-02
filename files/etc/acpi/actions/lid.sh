#!/bin/sh

_getXauthority() {
	local USER=`who | grep tty7 | head -1 | cut -f1 -d\ `
	echo "/home/$USER/.Xauthority"
}

_getDisplay() {
	who | grep tty7 | head -1 | cut -f2 -d\( | cut -f1 -d\)
}

[ "$3" == "open" ] && XAUTHORITY=`_getXauthority` DISPLAY=`_getDisplay` xrandr --auto

if [ "$3" == "close" ]; then
	XAUTHORITY=`_getXauthority`
	DISPLAY=`_getDisplay`
	PRIMARY=`XAUTHORITY=$XAUTHORITY DISPLAY=$DISPLAY xrandr | grep eDP | cut -f1 -d\ `
	XAUTHORITY=$XAUTHORITY DISPLAY=$DISPLAY xrandr --output "$PRIMARY" --off
	for DEVICE in `XAUTHORITY=$XAUTHORITY DISPLAY=$DISPLAY xrandr | grep -E '\bconnected\b' | grep -v "$PRIMARY" | cut -f1 -d\ `; do
		XAUTHORITY=$XAUTHORITY DISPLAY=$DISPLAY xrandr --output "$DEVICE" --auto
	done
fi

