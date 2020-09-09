#!/bin/bash

# Dependencies: i3lock-color

revert() {
    killall -SIGUSR2 dunst
    picom &
}

trap revert HUP INT TERM
killall -SIGUSR1 dunst
pkill -x picom

i3lock -n -t -e --blur=10 --indicator --clock --pass-media-keys --datestr="%a  %F" --datecolor=ffffffff --timecolor=ffffffff --ringcolor=2075c7ff --time-font=monospace

revert
