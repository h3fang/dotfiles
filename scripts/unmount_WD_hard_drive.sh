#!/bin/bash

set -eEuo pipefail
error_exit() {
    s=$?
    echo "$0: Error on line $LINENO: $BASH_COMMAND"
    exit $s
}
trap error_exit ERR

EHD_DRIVE=$(udisksctl status | grep 'Seagate BUP Slim SL' | grep 'NA9LNX7B' | awk '{print $NF}')
lsblk -l /dev/"$EHD_DRIVE" | grep part | awk '{print $1}'| xargs -I{} udisksctl unmount -b /dev/{}
udisksctl power-off -b /dev/"$EHD_DRIVE"
echo "powered-off /dev/$EHD_DRIVE"
