#!/bin/bash

if [[ $(pgrep -c systemd-udevd) -gt 3 ]]; then
    systemctl restart systemd-udevd
fi
