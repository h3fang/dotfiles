#!/bin/bash

set -eEuo pipefail
failure() {
    echo "line: $1 command: $2"
    exit "$3"
}
trap 'failure ${LINENO} "$BASH_COMMAND" $?' ERR

s_uefi() {
    echo "checking UEFI ..."
    if [[ ! -d /sys/firmware/efi/efivars ]]; then
        exit 1
    fi
}

s_partitions() {
    echo "making partitions ..."
    parted -s /dev/nvme0n1 -a optimal -- mklabel gpt \
    mkpart primary fat32 1MiB 1GiB \
    set 1 esp on \
    name 1 boot \
    mkpart primary 1GiB 100GiB \
    name 2 root \
    mkpart primary 100GiB -1MiB \
    name 3 home
}

s_formating() {
    echo "formating partitions ..."
    mkfs.fat -F32 /dev/nvme0n1p1
    mkfs.ext4 /dev/nvme0n1p2
    mkfs.ext4 /dev/nvme0n1p3
}

s_mounting() {
    echo "mounting partitions ..."
    mount /dev/nvme0n1p2 /mnt
    mkdir /mnt/{boot,home}
    mount /dev/nvme0n1p1 /mnt/boot
    mount /dev/nvme0n1p3 /mnt/home
}

s_mirrors() {
    echo "setting mirrors ..."
    echo "Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
    echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
}

s_pacstrap() {
    echo "installing basic packages ..."
    # firmwares can be customized later
    pacstrap /mnt base linux-zen e2fsprogs dosfstools linux-firmware neovim iwd
}

s_fstab() {
    echo "generating fstab ..."
    genfstab -U /mnt >> /mnt/etc/fstab
}

function ask_user {
    echo -e -n "\e[38;5;201m"
    echo -n "$1 ([y]/n)"
    echo -e -n '\e[0;0m'
    read -r
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        $2
    fi
}

### pre-chroot
ask_user "uefi?" s_uefi
ask_user "partitions?" s_partitions
ask_user "formating?" s_formating
ask_user "mounting?" s_mounting
ask_user "mirrors?" s_mirrors
ask_user "pacstrap?" s_pacstrap
ask_user "fstab?" s_fstab

## chroot
arch-chroot /mnt ./in_chroot.sh

### clean up
umount -R /mnt
reboot
