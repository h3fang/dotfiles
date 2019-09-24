#!/bin/bash
#########
### assuming /dev/sda2 is root, Asia/Shanghai timezone, en_US and zh_CN locale, systemd-boot, intel-ucode
#########

set -eEuo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

HostName=h3f-arch
UserName=h3f
RootUUID=$(blkid /dev/sda2 | awk '{print $5}')

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc

sed -i '/^#en_US.UTF-8 UTF-8/ s/^#//' /etc/locale.gen
sed -i '/^#zh_CN.GB18030 GB18030/ s/^#//' /etc/locale.gen
sed -i '/^#zh_CN.UTF-8 UTF-8/ s/^#//' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf

echo > /etc/hostname <<EOF
$HostName
127.0.0.1 localhost
::1 localhost
127.0.1.1 ${HostName}.local ${HostName}
EOF

mkinitcpio -p linux
bootctl --path=/boot install
echo "setting root password..."
passwd root
useradd -m -G wheel -s /bin/bash $UserName
echo "setting $UserName password..."
passwd $UserName
echo "$UserName ALL=(ALL) ALL" >> /etc/sudoers

echo > /etc/pacman.d/hooks/100-systemd-boot.hook <<EOF
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Updating systemd-boot
When = PostTransaction
Exec = /usr/bin/bootctl update
EOF

echo > /boot/loader/loader.conf <<EOF
timeout 3
default arch
editor no
EOF

echo > /boot/loader/entries/arch.conf <<EOF
title ArchLinux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=$RootUUID rw quiet nvidia-drm.modeset=1 nmi_watchdog=0 nowatchdog random.trust_cpu=on
EOF