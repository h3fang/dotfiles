#!/bin/bash

set -eEuo pipefail
failure() {
    echo "line: $1 command: $2"
    exit $3
}
trap 'failure ${LINENO} "$BASH_COMMAND" $?' ERR

EHD_DRIVE=$(udisksctl status | grep 'Seagate BUP Slim SL' | grep 'NA9LNX7B' | awk '{print $NF}')
lsblk -l /dev/"$EHD_DRIVE" | grep part | awk '{print $1}'| xargs -I{} udisksctl unmount -b /dev/{}
udisksctl power-off -b /dev/"$EHD_DRIVE"
echo "powered-off /dev/$EHD_DRIVE"
