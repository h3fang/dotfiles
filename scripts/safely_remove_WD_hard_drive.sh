#!/bin/bash

EHD_DRIVE=$(udisksctl status | grep Seagate | grep NA9LNX7B | awk '{print $NF}')
lsblk -l /dev/$EHD_DRIVE | grep part | awk '{print $1}'| xargs -i udisksctl unmount -b /dev/{}
udisksctl power-off -b /dev/$EHD_DRIVE
echo "powered-off /dev/$EHD_DRIVE"

