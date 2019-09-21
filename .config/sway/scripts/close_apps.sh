#!/bin/bash

# check transmission
if [[ $(pgrep transmission) ]]; then
    notify-send -u critical "transmission is still running."
    exit 1
fi

# kill windows
swaymsg [class="."] kill
swaymsg [app_id="."] kill

# wait a little while
sleep 3

# check remaining windows
apps=$(swaymsg -t get_tree | grep -P "app_id|class" | awk '{print $2}' | tr -d ',"' | sed "/^null$/d" | sort)
n_apps=$(echo $apps | awk '{print NF}')
if [[ $n_apps -gt 0 ]]; then
    notify-send -u critical "$(echo -e "$n_apps running application(s).\n$apps")"
    exit 2
fi

# I don't know why it doesn't quit and causing problems on next login.
#kill $(pidof gnome-keyring-daemon)
# This is weird too, but it doen't happen on the other desktop.
killall -s 9 i3blocks

# unmount
udiskie-umount -ad
