#!/bin/bash
#########
### assuming Asia/Shanghai timezone, en_US and zh_CN locale, linux-zen kernel, zsh for created user
#########

set -eEuo pipefail
failure() {
    echo "line: $1 command: $2"
    exit $3
}
trap 'failure ${LINENO} "$BASH_COMMAND" $?' ERR

HostName=arch
UserName=h3f
RootUUID=$(blkid /dev/nvme0n1p2 | awk '{print $5}')

pacman -S --needed base-devel git git-delta git-lfs zsh zsh-syntax-highlighting zsh-autosuggestions zsh-completions neovim

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc

sed -i '/^#en_US.UTF-8 UTF-8/ s/^#//' /etc/locale.gen
sed -i '/^#zh_CN.UTF-8 UTF-8/ s/^#//' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'LC_PAPER=zh_CN.UTF-8' >> /etc/locale.conf
echo 'A4' >> /etc/papersize

echo "$HostName" > /etc/hostname
cat > /etc/hosts <<EOF
127.0.0.1 localhost
::1 localhost
EOF

mkinitcpio -p linux
echo "setting root password..."
passwd root
useradd -m -G wheel -s /usr/bin/zsh $UserName
echo "setting $UserName password..."
passwd $UserName
echo "$UserName ALL=(ALL:ALL) ALL" >> /etc/sudoers.d/$UserName

Microcode=""
echo 'Microcode?'
select ucode in "amd" "intel"; do
    case $ucode in
        amd ) pacman -S amd-ucode; Microcode="amd-ucode"; break;;
        intel ) pacman -S intel-ucode; Microcode="intel-ucode"; break;;
    esac
done

bootctl --path=/boot install

cat > /etc/pacman.d/hooks/100-systemd-boot.hook <<EOF
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Updating systemd-boot
When = PostTransaction
Exec = /usr/bin/bootctl update
EOF

cat > /boot/loader/loader.conf <<EOF
timeout 3
default arch
editor no
EOF

cat > /boot/loader/entries/arch.conf <<EOF
title Arch Linux
linux /vmlinuz-linux-zen
initrd /${Microcode}.img
initrd /initramfs-linux-zen.img
options root=$RootUUID rw quiet nmi_watchdog=0 audit=0
EOF

