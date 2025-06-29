#!/bin/bash
#########
### assuming UEFI, *entire* /dev/sda disk (>100GiB), Intel microcode
#########

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
    parted -s /dev/sda -a optimal -- mklabel gpt \
    mkpart primary fat32 1MiB 513MiB \
    set 1 esp on \
    name 1 boot \
    mkpart primary 513MiB 100GiB \
    name 2 root \
    mkpart primary 100GiB -1MiB \
    name 3 home
}

s_formating() {
    echo "formating partitions ..."
    mkfs.fat -F32 /dev/sda1
    mkfs.ext4 /dev/sda2
    mkfs.ext4 /dev/sda3
}

s_mounting() {
    echo "mounting partitions ..."
    mount /dev/sda2 /mnt
    mkdir /mnt/{boot,home}
    mount /dev/sda1 /mnt/boot
    mount /dev/sda3 /mnt/home
}

s_mirrors() {
    echo "setting mirrors ..."
    echo "Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
    echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
}

s_pacstrap() {
    echo "installing basic packages ..."
    pacstrap /mnt base linux e2fsprogs dosfstools linux-firmware neovim iwd
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
