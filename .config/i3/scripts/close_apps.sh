#!/bin/bash
# requires i3-wm, jq, libnotify, udiskie

# check transmission
if [[ $(pgrep -f transmission) ]]; then
    notify-send -u critical "transmission is still running."
    exit 1
fi

# kill windows
i3-msg [class="."] kill

# wait for apps to quit
sleep 3

# check remaining windows
apps=$(i3-msg -t get_tree | jq '.. | select(.class? and .class != "i3bar").class' | sort)
n_apps=$(echo $apps | awk '{print NF}')
if [[ $n_apps -gt 0 ]]; then
    notify-send -u critical "$(echo -e "$n_apps running application(s).\n$apps")"
    exit 1
fi

# check backgroud programs
pkill -x xss-lock -SIGINT
pkill -f gnome-keyring-daemon
pkill -f systembus-notify
pkill -f networkd-notify

# unmount
sync
if ! udiskie-umount -ad; then
    notify-send -u critical 'failed to run "udiskie-umount -ad"'
    exit 1
fi

