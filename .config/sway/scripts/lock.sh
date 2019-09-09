#!/bin/bash
# requires swaylock-effects, sway (for swaymsg), jq (json parsing), pulseaudio (for pacmd)

if [[ $1 != "force" ]]; then
    chromium_focused=$(swaymsg -t get_tree | jq -r '.. | select(.window_properties?.class == "Chromium") | .focused' | grep "true" | wc -l)
    chromium_playing=$(pacmd list-sink-inputs | grep 'application.name = "Chromium"' | wc -l)
    if [[ $chromium_focused -gt 0 && $chromium_playing -gt 0 ]]; then
        echo "Inhibit idle while chromium is focused and playing"
        exit 1
    fi
fi

swaylock --screenshots --clock --indicator --effect-blur 10x3 --datestr="%a %F" --ring-color=2075c7ff --font=monospace -fel --indicator-radius 150
