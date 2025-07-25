#!/bin/bash
# Note: the name of the laptop display might be different under different kernels (e.g. eDP-1-1 for linux 5.2 and eDP-1 for linux-lts 4.19), double check it

set -eEuo pipefail
failure() {
    echo "line: $1 command: $2"
    exit "$3"
}
trap 'failure ${LINENO} "$BASH_COMMAND" $?' ERR

F_X11_CONF="/etc/X11/xorg.conf"
F_NV_OUTPUTCLASS="/etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf"
F_NVIDIA_BLACKLIST="/etc/modprobe.d/blacklist_nvidia.conf"
F_NOUVEAU_BLACKLIST=( "/usr/lib/modprobe.d/nvidia.conf" "/usr/lib/modprobe.d/nvidia-dkms.conf" )
F_NV_HOOK="/etc/pacman.d/hooks/nvidia.hook"
F_XINITRC="/home/${SUDO_USER}/.xinitrc"

function use_nvidia {
    pacman -Qi nvidia || pacman -Qi nvidia-dkms

    rm "$F_X11_CONF"

    if [[ -e $F_NV_OUTPUTCLASS.backup ]]; then
        mv $F_NV_OUTPUTCLASS.backup $F_NV_OUTPUTCLASS
    fi

    # do not poweroff nvidia GPU
    systemctl disable disable_nvidia.service

    # remove nvidia from blacklist
    if [[ -e $F_NVIDIA_BLACKLIST ]]; then
        mv $F_NVIDIA_BLACKLIST $F_NVIDIA_BLACKLIST.backup
    fi

    # blacklist nouveau
    for blist in "${F_NOUVEAU_BLACKLIST[@]}"; do
        if [[ -e $blist.backup ]]; then
            mv "$blist".backup "$blist"
        fi
    done

    # comment out all PRIME settings
    sed -i '/^xrandr --set/ s/^/#/' "$F_XINITRC"
    # enable reverse PRIME for nvidia
    sed -i '/^#xrandr --setprovideroutputsource modesetting NVIDIA-0/ s/^#//' "$F_XINITRC"

    # setup display
    # uncomment nvidia setting
    sed -i '/^#xrandr --output eDP-1-1/ s/^#//' "$F_XINITRC"
    # comment out intel setting
    sed -i '/^xrandr --auto --dpi 144/ s/^/#/' "$F_XINITRC"
    # comment out nouveau setting
    sed -i '/^xrandr --output eDP1/ s/^/#/' "$F_XINITRC"
    sed -i '/^xrandr --output HDMI/ s/^/#/' "$F_XINITRC"

    # fix kernel modules
    sed -i '/^MODULES=(intel_agp i915 nouveau)$/ s/^/#/' /etc/mkinitcpio.conf
    sed -i '/^#MODULES=(intel_agp i915 nvidia nvidia_modeset nvidia_uvm nvidia_drm)$/ s/^#//' /etc/mkinitcpio.conf
    sed -i '/^MODULES=(intel_agp i915)$/ s/^/#/' /etc/mkinitcpio.conf
    mkinitcpio -P

    if [[ -e $F_NV_HOOK.backup ]]; then
        mv $F_NV_HOOK.backup $F_NV_HOOK
    fi
}

function use_intel {
    cp "$F_X11_CONF".intel "$F_X11_CONF"

    # poweroff nvidia GPU
    systemctl enable disable_nvidia.service

    # blacklist nvidia
    if [[ -e $F_NVIDIA_BLACKLIST.backup ]]; then
        mv $F_NVIDIA_BLACKLIST.backup $F_NVIDIA_BLACKLIST
    fi

    # blacklist nouveau
    for blist in "${F_NOUVEAU_BLACKLIST[@]}"; do
        if [[ -e $blist.backup ]]; then
            mv "$blist".backup "$blist"
        fi
    done

    # disable PRIME
    sed -i '/^xrandr --set/ s/^/#/' "$F_XINITRC"

    # setup display
    sed -i '/^xrandr --output / s/^/#/' "$F_XINITRC"
    sed -i '/^#xrandr --auto --dpi 144/ s/^#//' "$F_XINITRC"

    # fix kernel modules
    sed -i '/^MODULES=(intel_agp i915 nouveau)$/ s/^/#/' /etc/mkinitcpio.conf
    sed -i '/^MODULES=(intel_agp i915 nvidia nvidia_modeset nvidia_uvm nvidia_drm)$/ s/^/#/' /etc/mkinitcpio.conf
    sed -i '/^#MODULES=(intel_agp i915)$/ s/^#//' /etc/mkinitcpio.conf
    mkinitcpio -P

    if [[ -e $F_NV_HOOK ]]; then
        mv $F_NV_HOOK $F_NV_HOOK.backup
    fi
}

# to get PRIME work with nouveau, xf86-video-nouveau must be installed
function use_nouveau {
    cp "$F_X11_CONF".nouveau "$F_X11_CONF"

    if [[ -e $F_NV_OUTPUTCLASS ]]; then
        mv $F_NV_OUTPUTCLASS $F_NV_OUTPUTCLASS.backup
    fi

    # do not poweroff nvidia GPU
    systemctl disable disable_nvidia.service

    # blacklist nvidia
    if [[ -e $F_NVIDIA_BLACKLIST.backup ]]; then
        mv $F_NVIDIA_BLACKLIST.backup $F_NVIDIA_BLACKLIST
    fi

    # remove nouveau from blacklist
    for blist in "${F_NOUVEAU_BLACKLIST[@]}"; do
        if [[ -e $blist ]]; then
            mv "$blist" "$blist".backup
        fi
    done

    # comment out all PRIME settings
    sed -i '/^xrandr --set/ s/^/#/' "$F_XINITRC"
    # enable reverse PRIME for nouveau
    sed -i '/^#xrandr --setprovideroutputsource modesetting nouveau/ s/^#//' "$F_XINITRC"

    # setup display
    # comment out nvidia setting
    sed -i '/^xrandr --output eDP-1-1/ s/^/#/' "$F_XINITRC"
    # comment out intel setting
    sed -i '/^xrandr --auto --dpi 144/ s/^/#/' "$F_XINITRC"
    # uncomment nouveau setting
    sed -i '/^#xrandr --output eDP1/ s/^#//' "$F_XINITRC"
    sed -i '/^#xrandr --output HDMI/ s/^#//' "$F_XINITRC"

    # fix kernel modules
    sed -i '/^#MODULES=(intel_agp i915 nouveau)$/ s/^#//' /etc/mkinitcpio.conf
    sed -i '/^MODULES=(intel_agp i915 nvidia nvidia_modeset nvidia_uvm nvidia_drm)$/ s/^/#/' /etc/mkinitcpio.conf
    sed -i '/^MODULES=(intel_agp i915)$/ s/^/#/' /etc/mkinitcpio.conf
    mkinitcpio -P

    if [[ -e $F_NV_HOOK ]]; then
        mv $F_NV_HOOK $F_NV_HOOK.backup
    fi
}

if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run as root"
    exit 1
fi

if [[ $1 == "nvidia" ]]; then
    use_nvidia
elif [[ $1 == "intel" ]]; then
    use_intel
elif [[ $1 == "nouveau" ]]; then
    use_nouveau
else
    echo "Error: Invalid arguments"
    exit 2
fi
