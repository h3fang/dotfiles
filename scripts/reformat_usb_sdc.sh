#!/bin/sh

lsblk -f /dev/sdc

read -p "Continue to reformat /dev/sdc? (yes|[no])" -r
if [[ $REPLY == "yes" ]]
then
    udiskie-umount /dev/sdc1
    sudo wipefs --all /dev/sdc
    sudo parted -s /dev/sdc mklabel gpt mkpart primary fat32 0% 100%
    udiskie-umount /dev/sdc1
    sudo mkfs.fat -F 32 -n HEF /dev/sdc1
fi

