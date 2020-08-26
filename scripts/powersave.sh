#!/bin/bash
# requires brightnessctl, tlp

set -eEuo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

function setup() {
    ### compositor
    pkill picom || true

    ### backlight brightness
    brightnessctl s 10%

    ### manual mode for TLP
    sudo tlp bat

    ### disable CPU Turbo Boost (AMD / acpi-cpufreq)
    echo 0 | sudo tee /sys/devices/system/cpu/cpufreq/boost

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
    echo 1 | sudo tee /sys/devices/system/cpu/cpufreq/boost

    ### enable CPU SMT/HT
    echo on | sudo tee /sys/devices/system/cpu/smt/control
}

if [[ $1 == "on" ]]; then
    setup
elif [[ $1 == "off" ]]; then
    restore
fi

