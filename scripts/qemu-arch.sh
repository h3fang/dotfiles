#!/bin/bash

#~/scripts/download_and_verify_latest_iso.sh

#qemu-img create -f qcow2 arch.qcow2 16G

qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -m 2048 \
    -nic user,model=virtio \
    -drive file=arch.qcow2,media=disk,if=virtio \
    -smp 4 \
#    -cdrom ~/Downloads/archlinux-2019.09.01-x86_64.iso
