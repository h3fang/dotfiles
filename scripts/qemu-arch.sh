#!/bin/bash

#ARCHISO_VER=$(date +%Y.%m.01)
#~/scripts/download_and_verify_latest_iso.sh

#qemu-img create -f qcow2 arch.qcow2 16G

qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -smp $(nproc) \
    -m 2048 \
    -nic user,model=virtio \
    -drive file=arch.qcow2,media=disk,if=virtio \
#    -cdrom ~/Downloads/archlinux-${ARCHISO_VER}-x86_64.iso \
#    -boot menu=on
