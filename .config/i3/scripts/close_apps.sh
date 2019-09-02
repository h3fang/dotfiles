#!/bin/bash
# requires xorg-xprop, libnotify, udiskie

# check transmission
if [[ $(pgrep transmission) ]]; then
    notify-send -u critical "transmission is still running."
    exit 1
fi

i3-msg [class="."] kill

sleep 3

# check every window
n_apps=$(xprop -root | grep '_NET_CLIENT_LIST(WINDOW)' | egrep -o '0x[0-9a-zA-Z]*' | wc -l)
if [[ $n_apps -gt 0 ]]; then
    notify-send -u critical "$n_apps applications are still running, please check unsaved content and close it manually."
    exit 2
fi

kill $(pidof gnome-keyring-daemon)

udiskie-umount -ad

