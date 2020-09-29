#!/bin/bash

WIN10_IMG=${HOME}/VMs/"Win10_2004_Chinese(Simplified)_x64.iso"
VIRTIO_IMG=${HOME}/VMs/virtio-win-0.1.171.iso
DISK_IMG=${HOME}/VMs/win10.qcow2

function create_disk {
    qemu-img create -f qcow2 "${DISK_IMG}" 20G
}

function install {
    qemu-system-x86_64 -m 4G -smp 4 -enable-kvm \
    -nodefaults \
    -cpu host \
    -drive file="${DISK_IMG}",index=0,media=disk,if=virtio \
    -nic user,model=virtio,hostfwd=tcp::10022-:22 \
    -rtc base=localtime,clock=host \
    -audiodev pa,id=pa0,server=/run/user/$UID/pulse/native \
    -device intel-hda -device hda-duplex,audiodev=pa0 \
    -vga virtio \
    -drive file="${WIN10_IMG}",index=2,media=cdrom \
    -drive file="${VIRTIO_IMG}",index=3,media=cdrom
}

function run {
    qemu-system-x86_64 -m 4G -smp 4 -enable-kvm \
    -nodefaults \
    -cpu host \
    -drive file="${DISK_IMG}",if=virtio \
    -nic user,model=virtio-net-pci,hostfwd=tcp::10022-:22 \
    -rtc base=localtime,clock=host \
    -audiodev pa,id=pa0,server=/run/user/$UID/pulse/native \
    -device intel-hda -device hda-duplex,audiodev=pa0 \
    -vga virtio \
    -full-screen &
}


CMD=${1:-run}
if [[ "$CMD" == "disk" ]]; then
    create_disk
elif [[ "$CMD" == "install" ]]; then
    install
elif [[ "$CMD" == "run" ]]; then
    run
fi

