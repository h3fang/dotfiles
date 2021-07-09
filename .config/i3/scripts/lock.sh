#!/bin/bash

# Dependencies: i3lock-color

i3lock_options=(-t -e --blur=30 --indicator --clock --pass-media-keys --date-str="%a  %F" --date-color=ffffffff --time-color=ffffffff --ring-color=2075c7ff --time-font=monospace)

pre_lock() {
    dunstctl set-paused true
    pkill -x picom
}

post_lock() {
    dunstctl set-paused false
    picom -b
}

trap post_lock HUP INT TERM

pre_lock

if [[ -e /dev/fd/${XSS_SLEEP_LOCK_FD:--1} ]]; then
    kill_i3lock() {
        pkill -xu $EUID "$@" i3lock
    }

    trap kill_i3lock TERM INT

    i3lock "${i3lock_options[@]}" {XSS_SLEEP_LOCK_FD}<&-
    sleep 1

    exec {XSS_SLEEP_LOCK_FD}<&-

    while kill_i3lock -0; do
        sleep 0.5
    done
else
    trap 'kill %%' TERM INT
    i3lock -n "${i3lock_options[@]}" &
    sleep 1
    wait
fi

post_lock

