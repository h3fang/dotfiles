#!/bin/bash

set -eu

WIN10_IMG=$(fd -e iso Win10 "$HOME/VMs" | head -n1)
VIRTIO_IMG=$(fd -e iso virtio-win "$HOME/VMs" | head -n1)
DISK_IMG=${HOME}/VMs/win10.qcow2

function create_disk {
    qemu-img create -f qcow2 "${DISK_IMG}" 50G
}

function install {
    qemu-system-x86_64 -m 4G -smp 8 -enable-kvm \
    -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
    -drive file="${DISK_IMG}",index=0,media=disk,if=virtio \
    -drive file="${WIN10_IMG}",index=2,media=cdrom \
    -drive file="${VIRTIO_IMG}",index=3,media=cdrom \
    -nic user,model=virtio-net-pci \
    -rtc base=localtime,clock=host \
    -audiodev pa,id=snd0 \
    -device ich9-intel-hda -device hda-micro,audiodev=snd0 &
}

    #-display gtk,gl=on \
function run {
    qemu-system-x86_64 -m 4G -smp $(nproc) -enable-kvm \
    -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
    -drive file="${DISK_IMG}",if=virtio \
    -nic user,model=virtio-net-pci,hostfwd=tcp::10022-:22 \
    -rtc base=localtime,clock=host \
    -audiodev pa,id=snd0 \
    -device ich9-intel-hda -device hda-micro,audiodev=snd0 \
    -device usb-ehci,id=ehci -device usb-host,bus=ehci.0,vendorid=0x04f2,productid=0xb6cb &
}


CMD=${1:-run}
if [[ "$CMD" == "disk" ]]; then
    create_disk
elif [[ "$CMD" == "install" ]]; then
    install
elif [[ "$CMD" == "run" ]]; then
    run
else
    echo "Usage: $(basename $0) disk|install|[run]"
fi

