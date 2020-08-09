#!/bin/bash

#ARCHISO_VER=$(date +%Y.%m.01)
#~/scripts/download_and_verify_latest_iso.sh ~/VMs

DISK_IMG=${HOME}/VMs/arch.qcow2
#qemu-img create -f qcow2 "${DISK_IMG}" 20G

qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -smp 4 \
    -m 4G \
    -nic user,model=virtio \
    -drive file="${DISK_IMG}",media=disk,if=virtio \
#    -cdrom ~/VMs/archlinux-${ARCHISO_VER}-x86_64.iso \
#    -boot menu=on
