#!/bin/bash

set -eEuo pipefail
error_exit() {
    s=$?
    echo "$0: Error on line $LINENO"
    exit $s
}
trap error_exit ERR

usb_disk=$(lsblk | grep disk | awk '{print $1}' | fzf --preview 'lsblk' --header 'Choose usb disk')
lsblk -f /dev/"${usb_disk}"

read -p "Continue to reformat /dev/${usb_disk}? (yes|[no])" -r
if [[ $REPLY == "yes" ]]
then
    # sudo umount /dev/"${usb_disk}"1 || true
    sudo wipefs --all /dev/"${usb_disk}"
    sudo parted -s /dev/"${usb_disk}" mklabel msdos mkpart primary fat32 0% 100%
    sudo umount /dev/"${usb_disk}"1 || true
    sudo mkfs.fat -F 32 -n HEF /dev/"${usb_disk}"1
fi

