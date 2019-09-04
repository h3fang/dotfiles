#!/bin/bash

# Dependencies: i3lock-color

revert() {
    killall -SIGUSR2 dunst
}

trap revert HUP INT TERM
killall -SIGUSR1 dunst

i3lock -n -t -e --blur=10 --indicator --clock --pass-media-keys --datecolor=ffffffff --timecolor=ffffffff --ringcolor=2075c7ff --time-font=monospace

revert
