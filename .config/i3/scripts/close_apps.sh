#!/bin/sh

wmctrl -c Transmission

i3-msg [class="."] kill
kill $(pidof gnome-keyring-daemon)

sync
#devmon -r && pkill udevil
udiskie-umount -ad

sleep 3

# check transmission
while [[ $(pidof transmission-qt) ]]; do
    notify-send "transmission-qt is still running."
    sleep 3600
done

# check every window
wmctrl -l | awk '{print $1}' | while read APP; do
    notify-send "[$APP] is not closed, please check unsaved content and close it manually."
    sleep 3600
done

