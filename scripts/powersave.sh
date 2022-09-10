#!/bin/bash
# requires brightnessctl, tlp

set -eEuo pipefail
error_exit() {
    s=$?
    echo "$0: Error on line $LINENO: $BASH_COMMAND"
    exit $s
}
trap error_exit ERR

function setup() {
    ### compositor
    pkill picom || true

    ### backlight brightness
    brightnessctl s 10%

    ### manual mode for TLP
    sudo tlp bat

    ### disable CPU Turbo Boost (AMD / acpi-cpufreq)
    if [[ -f /sys/devices/system/cpu/cpufreq/boost ]]; then
        echo 0 | sudo tee /sys/devices/system/cpu/cpufreq/boost
    fi

    ### disable CPU SMT/HT
    echo off | sudo tee /sys/devices/system/cpu/smt/control
}

function restore() {
    ### compositor
    if [[ -n $(pidof i3) ]]; then
        i3-msg "exec --no-startup-id picom"
    fi

    ### backlight brightness
    brightnessctl s 35%

    ### manual mode for TLP
    sudo tlp ac

    ### enable CPU Turbo Boost (AMD / acpi-cpufreq)
    if [[ -f /sys/devices/system/cpu/cpufreq/boost ]]; then
        echo 1 | sudo tee /sys/devices/system/cpu/cpufreq/boost
    fi

    ### enable CPU SMT/HT
    echo on | sudo tee /sys/devices/system/cpu/smt/control
}

if [[ $1 == "on" ]]; then
    setup
elif [[ $1 == "off" ]]; then
    restore
fi

