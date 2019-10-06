#!/bin/bash

set -eEuo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

CONTROLLER_BUS_ID=0000:00:01.0
DEVICE_BUS_ID=0000:01:00.0

rmmod nvidia_drm nvidia_modeset nvidia_uvm nvidia || true

echo 'Removing Nvidia bus from the kernel'
tee /sys/bus/pci/devices/${DEVICE_BUS_ID}/remove <<<1

echo 'Enabling powersave for the PCIe controller'
tee /sys/bus/pci/devices/${CONTROLLER_BUS_ID}/power/control <<<auto
