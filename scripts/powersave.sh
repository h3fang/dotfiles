#!/bin/bash
# requires brightnessctl, tlp

set -eEuo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

function setup() {
    ### compositor
    pkill compton || true

    ### backlight brightness
    brightnessctl s 10%

    ### manual mode for TLP
    sudo tlp bat

    ### cpu hyperthread
    for i in $(cat /sys/devices/system/cpu/cpu*/topology/thread_siblings_list | awk -F- '{print $2}' | sort -n | uniq); do
        echo disabling hyperthread $i
        echo 0 | sudo tee /sys/devices/system/cpu/cpu$i/online
    done
}

function restore() {
    ### compositor
    if [[ -n $(pidof i3) ]]; then
        i3-msg "exec --no-startup-id compton"
    fi

    ### backlight brightness
    brightnessctl s 30%

    ### manual mode for TLP
    sudo tlp ac

    ### cpu hyperthread
    for i in /sys/devices/system/cpu/cpu*/online; do
        echo 1 | sudo tee "${i}"
    done
}

if [[ $1 == "on" ]]; then
    setup
elif [[ $1 == "off" ]]; then
    restore
fi
