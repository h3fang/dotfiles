#!/bin/bash
# requires swaylock-effects, sway (for swaymsg), jq (json parsing), pulseaudio (for pacmd)

if [[ $1 != "force" ]]; then
    firefox_focused=$(swaymsg -t get_tree | jq -r '.. | select(.app_id? == "firefox") | .focused' | grep "true" | wc -l)
    firefox_playing=$(pacmd list-sink-inputs | grep 'application.name = "Firefox"' | wc -l)
    if [[ $firefox_focused -gt 0 && $firefox_playing -gt 0 ]]; then
        echo "Inhibit idle while Firefox is focused and playing."
        exit 1
    fi
fi

dunstctl set-paused true

swaylock -f --screenshots --clock --indicator --effect-blur 30x3 --datestr="%a %F" --ring-color=2075c7ff --font=monospace -fel --indicator-radius 150

dunstctl set-paused false
