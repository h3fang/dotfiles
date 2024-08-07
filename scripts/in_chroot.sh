#!/bin/bash
#########
### assuming /dev/sda2 is root, Asia/Shanghai timezone, en_US and zh_CN locale, vanilla linux kernel, bash for created user
#########

set -eEuo pipefail
failure() {
    echo "line: $1 command: $2"
    exit $3
}
trap 'failure ${LINENO} "$BASH_COMMAND" $?' ERR

HostName=h3f-arch
UserName=h3f
RootUUID=$(blkid /dev/sda2 | awk '{print $5}')

pacman -S base-devel git

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc

sed -i '/^#en_US.UTF-8 UTF-8/ s/^#//' /etc/locale.gen
sed -i '/^#zh_CN.GB18030 GB18030/ s/^#//' /etc/locale.gen
sed -i '/^#zh_CN.UTF-8 UTF-8/ s/^#//' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'LC_PAPER=zh_CN.UTF-8' >> /etc/locale.conf
echo 'A4' >> /etc/papersize

cat > /etc/hostname <<EOF
$HostName
127.0.0.1 localhost
::1 localhost
127.0.1.1 ${HostName}.local ${HostName}
EOF

mkinitcpio -p linux
echo "setting root password..."
passwd root
useradd -m -G wheel -s /bin/bash $UserName
echo "setting $UserName password..."
passwd $UserName
echo "$UserName ALL=(ALL) ALL" >> /etc/sudoers

Microcode=""
echo 'Microcode?'
select ucode in "amd" "intel"; do
    case $ucode in
        amd ) pacman -S amd-ucode; Microcode="amd-ucode"; break;;
        intel ) pacman -S intel-ucode; Microcode="intel-ucode"; break;;
    esac
done

function bl_systemd_boot {
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
title ArchLinux
linux /vmlinuz-linux
initrd /${Microcode}.img
initrd /initramfs-linux.img
options root=$RootUUID rw quiet nmi_watchdog=0 audit=0 module.sig_enforce=1
EOF
}

echo 'Boot loader?'
select bl in "grub-mbr" "grub-uefi" "systemd-boot"; do
    case $bl in
        grub-mbr )
            pacman -S grub ntfs-3g os-prober
            grub-install --target=i386-pc /dev/sda
            grub-mkconfig -o /boot/grub/grub.cfg
            break;;
        grub-uefi )
            pacman -S grub ntfs-3g os-prober
            grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
            grub-mkconfig -o /boot/grub/grub.cfg
            break;;
        systemd-boot ) bl_systemd_boot; break;;
    esac
done
