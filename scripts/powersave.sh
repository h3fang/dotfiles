#!/bin/bash
# requires brightnessctl, tlp, python-undervolt

function setup() {
    ### compositor
    pkill compton

    ### backlight brightness
    brightnessctl s 10%

    ### manual mode for TLP
    tlp bat

    ### undervolting Intel cpu
    undervolt --core -100 --uncore -100 --analogio -100 --cache -100 --gpu -100

    ### cpu hyperthread
    cat /sys/devices/system/cpu/cpu*/topology/thread_siblings_list | \
    awk -F, '{print $2}' | \
    sort -n | \
    uniq | \
    ( while read X ; do echo disabling hyperthread $X ; echo 0 > /sys/devices/system/cpu/cpu$X/online ; done )
}

function restore() {
    ### compositor
    if [[ -n $(pidof i3) ]]; then
	i3-msg "exec --no-startup-id compton"
    fi

    ### backlight brightness
    brightnessctl s 30%

    ### manual mode for TLP
    tlp ac

    ### undervolting Intel cpu
    undervolt --core 0 --uncore 0 --analogio 0 --cache 0 --gpu 0

    ### cpu hyperthread
    for i in /sys/devices/system/cpu/cpu*/online; do
        echo 1 > "${i}"
    done
}

if [[ $1 == "on" ]]; then
    setup
elif [[ $1 == "off" ]]; then
    restore
fi
