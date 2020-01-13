#!/bin/bash

set -eEuo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

EHD_DRIVE=$(udisksctl status | grep 'Seagate BUP Slim SL' | grep 'NA9LNX7B' | awk '{print $NF}')
lsblk -l /dev/$EHD_DRIVE | grep part | awk '{print $1}'| xargs -i udisksctl unmount -b /dev/{}
udisksctl power-off -b /dev/$EHD_DRIVE
echo "powered-off /dev/$EHD_DRIVE"
