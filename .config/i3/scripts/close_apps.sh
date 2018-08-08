#!/bin/sh

pkill transmission-qt
i3-msg [class="."] kill
sleep 3

# gracefully close all apps, needs wmctrl
wmctrl -l | awk '{print $1}' | while read APP; do
    notify-send "[$APP] not closed, please check unsaved content and close it manually."
    exit 1
done

devmon -r

