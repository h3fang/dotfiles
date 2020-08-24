#!/bin/bash

# Example notifier script -- lowers screen brightness, then waits to be killed
# and restores previous brightness on exit.

## CONFIGURATION ##############################################################

# Brightness will be lowered to this value.
min_brightness=0

# Time to sleep (in seconds) between increments when using sysfs. If unset or
# empty, fading is disabled.
fade_step_time=0.05

###############################################################################

get_brightness() {
    brightnessctl g
}

set_brightness() {
    brightnessctl -q s $1
}

fade_brightness() {
    if [[ -z $fade_step_time ]]; then
        set_brightness $1
    else
        local level
        for level in $(eval echo {$(get_brightness)..$1..2}); do
            set_brightness $level
            sleep $fade_step_time
        done
    fi
}

trap 'exit 0' TERM INT
trap "set_brightness $(get_brightness); kill %%" EXIT
fade_brightness $min_brightness
sleep 2147483647 &
wait
