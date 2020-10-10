#!/bin/sh

usb_disk=$(lsblk | grep disk | awk '{print $1}' | fzf --preview 'lsblk' --header 'Choose usb disk')
lsblk -f /dev/${usb_disk}

read -p "Continue to reformat /dev/${usb_disk}? (yes|[no])" -r
if [[ $REPLY == "yes" ]]
then
    udiskie-umount /dev/${usb_disk}1
    sudo wipefs --all /dev/${usb_disk}
    sudo parted -s /dev/${usb_disk} mklabel msdos mkpart primary fat32 0% 100%
    udiskie-umount /dev/${usb_disk}1
    sudo mkfs.fat -F 32 -n HEF /dev/${usb_disk}1
fi

