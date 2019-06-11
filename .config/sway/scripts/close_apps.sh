#!/usr/bin/bash

# check transmission
if [[ $(pidof transmission-qt) ]]; then
    notify-send "transmission-qt is still running."
    exit 1
fi

# kill windows
swaymsg [class="."] kill
swaymsg [app_id="."] kill

# unmount
udiskie-umount -ad

# wait a little while
sleep 3

