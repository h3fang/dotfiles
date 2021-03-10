#!/bin/bash

# Dependencies: i3lock-color

i3lock_options=(-t -e --blur=20 --indicator --clock --pass-media-keys --datestr="%a  %F" --datecolor=ffffffff --timecolor=ffffffff --ringcolor=2075c7ff --time-font=monospace)

pre_lock() {
    killall -SIGUSR1 dunst
    pkill -x picom
}

post_lock() {
    killall -SIGUSR2 dunst
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

    exec {XSS_SLEEP_LOCK_FD}<&-

    while kill_i3lock -0; do
        sleep 0.5
    done
else
    trap 'kill %%' TERM INT
    i3lock -n "${i3lock_options[@]}" &
    wait
fi

post_lock

