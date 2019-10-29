#!/bin/bash
#########
### assuming UEFI, *entire* /dev/sda disk (>100GiB), Intel CPU
#########

set -eEuo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

echo "checking UEFI ..."
ls /sys/firmware/efi/efivars

### pre-chroot

# partitions
parted -s /dev/sda -a optimal -- mklabel gpt \
    mkpart primary fat32 1MiB 513MiB \
    set 1 esp on \
    name 1 boot \
    mkpart primary 513MiB 100GiB \
    name 2 root \
    mkpart primary 100GiB -1MiB \
    name 3 home

# formating
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda3

# mounting
mount /dev/sda2 /mnt
mkdir /mnt/{boot,home}
mount /dev/sda1 /mnt/boot
mount /dev/sda3 /mnt/home

# mirrors
echo "$(echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' | cat - /etc/pacman.d/mirrorlist)" > /etc/pacman.d/mirrorlist
echo "$(echo 'Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux/$repo/os/$arch' | cat - /etc/pacman.d/mirrorlist)" > /etc/pacman.d/mirrorlist

# pacstrap
pacstrap /mnt base linux e2fsprogs dosfstools linux-firmware vim netctl dhclient # wpa_supplicant ppp ifplugd dialog # networkmanager # network-manager-applet

# fstab
genfstab -U /mnt >> /mnt/etc/fstab

### chroot

arch-chroot /mnt ./in_chroot.sh

### clean up
umount -R /mnt
reboot
