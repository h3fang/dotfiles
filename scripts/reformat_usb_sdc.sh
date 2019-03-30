#!/bin/sh

lsblk -f /dev/sdc

read -p "Continue to reformat /dev/sdc? (yes|[no])" -r
if [[ $REPLY == "yes" ]]
then
    udiskie-umount /dev/sdc1
    sudo wipefs --all /dev/sdc
    printf 'o\nn\np\n1\n\n\nt\nb\nw' | sudo fdisk -W always /dev/sdc
    udiskie-umount /dev/sdc1
    sudo mkfs.fat -F 32 -n HEF /dev/sdc1
fi

