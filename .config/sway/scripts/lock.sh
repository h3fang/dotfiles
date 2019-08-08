#!/bin/bash

if [[ $1 != "force" ]]; then
    chromium_focused=$(swaymsg -t get_tree | jq -r '.. | select(.window_properties?.class == "Chromium") | .focused' | grep "true" | wc -l)
    chromium_playing=$(pacmd list-sink-inputs | grep 'application.name = "Chromium"' | wc -l)
    if [[ $chromium_focused -gt 0 && $chromium_playing -gt 0 ]]; then
        echo "Inhibit idle while chromium is focused and playing"
        exit 1
    fi
fi

IMG=/tmp/swaylock-blur.png
grim $IMG
convert $IMG -blur 0x6 $IMG
composite -gravity center ~/Pictures/lock.png $IMG $IMG
swaylock -fel --indicator-radius 150 -i $IMG
rm $IMG
