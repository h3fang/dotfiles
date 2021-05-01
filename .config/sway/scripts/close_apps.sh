#!/bin/bash
# requires sway, jq, libnotify, udiskie

# check transmission
if [[ $(pgrep -f transmission) ]]; then
    notify-send -u critical "transmission is still running."
    exit 1
fi

# kill windows
swaymsg [class="."] kill
swaymsg [app_id="."] kill

# wait for apps to quit
sleep 3

# check remaining windows
apps=$(swaymsg -t get_tree | jq '.. | select(.class? or .app_id?) | .app_id+.class ' | sort)
n_apps=$(echo $apps | awk '{print NF}')
if [[ $n_apps -gt 0 ]]; then
    notify-send -u critical "$(echo -e "$n_apps running application(s).\n$apps")"
    exit 1
fi

# check backgroud programs
pkill -f gnome-keyring-daemon || true
pkill -f systembus-notify || true
pkill -f networkd-notify || true

# unmount
sync
if ! udiskie-umount -ad; then
    notify-send -u critical 'failed to run "udiskie-umount -ad"'
    exit 1
fi

