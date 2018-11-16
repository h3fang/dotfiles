#!/bin/sh

wmctrl -c Transmission

i3-msg [class="."] kill

devmon -r && pkill udevil
killall gnome-keyring-daemon

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

