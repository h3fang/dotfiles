#!/bin/bash
# requires swaylock-effects, dunst (dunstctl)

dunstctl set-paused true

swaylock_args=(-fel --indicator-radius 150 --ring-color 2075c7ff --font monospace --font-size 32)
# ~/.config/sway/scripts/swaylock-blur "${swaylock_args[@]}"
swaylock "${swaylock_args[@]}" --indicator --screenshots --clock --datestr "%a %F" --effect-scale 0.5 --effect-blur 32x3 --effect-scale 2

dunstctl set-paused false
