#!/bin/bash
# requires powertop, python-undervolt

function setup() {
    ### powertop auto tuning
    # maybe we should leave these managed by TLP
    powertop --auto-tune --quiet

    # disable autosuspend for wireless mouse
    echo 'on' > '/sys/bus/usb/devices/1-1/power/control'

    ### wakeups, check powertop wakeup page
    echo 'disabled' > '/sys/class/net/eno1/device/power/wakeup'
    echo 'disabled' > '/sys/bus/usb/devices/1-1/power/wakeup'

    ### undervolting cpu
    undervolt --core -100 --uncore -100 --analogio -100 --cache -100 --gpu -100

    ### cpu hyperthread
    cat /sys/devices/system/cpu/cpu*/topology/thread_siblings_list | \
    awk -F, '{print $2}' | \
    sort -n | \
    uniq | \
    ( while read X ; do echo disabling hyperthread $X ; echo 0 > /sys/devices/system/cpu/cpu$X/online ; done )
}

function restore() {
    ### wakeups, check powertop wakeup page
    echo 'disabled' > '/sys/class/net/eno1/device/power/wakeup'
    echo 'enabled' > '/sys/bus/usb/devices/1-1/power/wakeup'

    ### undervolting cpu
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
