#!/bin/bash

ARCHISO_VER=$(date +%Y.%m.01)
DISK_IMG=${HOME}/VMs/arch.qcow2

function install {
    ~/scripts/download_and_verify_latest_iso.sh ~/VMs
    qemu-img create -f qcow2 "${DISK_IMG}" 20G

    qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -smp 4 \
    -m 4G \
    -nic user,model=virtio \
    -drive file="${DISK_IMG}",media=disk,if=virtio \
    -cdrom ~/VMs/archlinux-${ARCHISO_VER}-x86_64.iso \
    -boot menu=on
}

function run {
    qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -smp 4 \
    -m 4G \
    -nic user,model=virtio \
    -drive file="${DISK_IMG}",media=disk,if=virtio \
    -vga virtio \
    -display gtk,gl=on
}

if [[ $# -eq 0 || $1 == "run" ]]; then
    run
elif [[ $1 == "install" ]]; then
    init
else
    echo "Usage: $(basename $0) [run|install]"
    exit 1
fi

