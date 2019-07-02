#!/bin/bash

wmctrl -c Transmission

i3-msg [class="."] kill

sleep 3

# check transmission
if [[ $(pgrep transmission) ]]; then
    notify-send "transmission is still running."
    exit 1
fi

# check every window
all_closed=1
wmctrl -l | awk '{print $1}' | while read APP; do
    notify-send "[$APP] is not closed, please check unsaved content and close it manually."
    $all_closed=0
done

if [[ $all_closed -eq 0 ]]; then
    exit 2
fi

udiskie-umount -ad

