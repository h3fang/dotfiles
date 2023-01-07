#!/bin/bash
# requires swaylock, dunst (dunstctl)

dunstctl set-paused true

swaylock -fel --indicator-radius 150 --ring-color 2075c7ff --font monospace --font-size 32 -i ~/Pictures/wallpapers/current

dunstctl set-paused false
