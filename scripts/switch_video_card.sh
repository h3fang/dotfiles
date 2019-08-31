#!/bin/bash

set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

F_X11_CONF="/etc/X11/xorg.conf"
F_NV_OUTPUTCLASS="/usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf"
F_NVIDIA_BLACKLIST="/usr/lib/modprobe.d/blacklist_nvidia.conf"
F_NOUVEAU_BLACKLIST="/usr/lib/modprobe.d/nvidia.conf"
F_NV_HOOK="/etc/pacman.d/hooks/nvidia.hook"

function use_nvidia {
    sudo cp $F_X11_CONF.nvidia $F_X11_CONF

    if [[ -e $F_NV_OUTPUTCLASS.backup ]]; then
        sudo mv $F_NV_OUTPUTCLASS.backup $F_NV_OUTPUTCLASS
    fi

    # do not poweroff nvidia GPU
    sudo systemctl disable disable_nvidia.service

    # remove nvidia from blacklist
    if [[ -e $F_NVIDIA_BLACKLIST ]]; then
        sudo mv $F_NVIDIA_BLACKLIST $F_NVIDIA_BLACKLIST.backup
    fi

    # blacklist nouveau
    if [[ -e $F_NOUVEAU_BLACKLIST.backup ]]; then
        sudo mv $F_NOUVEAU_BLACKLIST.backup $F_NOUVEAU_BLACKLIST
    fi

    # comment out all PRIME settings
    sed -i '/^xrandr --set/ s/^/#/' ~/.xinitrc
    # enable reverse PRIME for nvidia
    sed -i '/^#xrandr --setprovideroutputsource modesetting NVIDIA-0/ s/^#//' ~/.xinitrc

    # setup display
    # uncomment nvidia setting
    sed -i '/^#xrandr --output eDP-1-1/ s/^#//' ~/.xinitrc
    # comment out intel setting
    # sed -i '/^xrandr --auto --dpi 144/ s/^/#/' ~/.xinitrc
    # comment out nouveau setting
    sed -i '/^xrandr --output eDP1/ s/^/#/' ~/.xinitrc
    sed -i '/^xrandr --output HDMI/ s/^/#/' ~/.xinitrc

    # fix kernel modules
    sudo sed -i '/^MODULES=(intel_agp i915 nouveau)$/ s/^/#/' /etc/mkinitcpio.conf
    sudo sed -i '/^#MODULES=(intel_agp i915 nvidia nvidia_modeset nvidia_uvm nvidia_drm)$/ s/^#//' /etc/mkinitcpio.conf
    sudo sed -i '/^MODULES=(intel_agp i915)$/ s/^/#/' /etc/mkinitcpio.conf
    sudo mkinitcpio -P

    if [[ -e $F_NV_HOOK.backup ]]; then
        sudo mv $F_NV_HOOK.backup $F_NV_HOOK
    fi
}

function use_intel {
    sudo cp $F_X11_CONF.intel $F_X11_CONF

    # poweroff nvidia GPU
    sudo systemctl enable disable_nvidia.service

    # blacklist nvidia
    if [[ -e $F_NVIDIA_BLACKLIST.backup ]]; then
        sudo mv $F_NVIDIA_BLACKLIST.backup $F_NVIDIA_BLACKLIST
    fi

    # blacklist nouveau
    if [[ -e $F_NOUVEAU_BLACKLIST.backup ]]; then
        sudo mv $F_NOUVEAU_BLACKLIST.backup $F_NOUVEAU_BLACKLIST
    fi

    # disable PRIME
    sed -i '/^xrandr --set/ s/^/#/' ~/.xinitrc

    # setup display
    sed -i '/^xrandr --output / s/^/#/' ~/.xinitrc
    sed -i '/^#xrandr --auto --dpi 144/ s/^#//' ~/.xinitrc

    # fix kernel modules
    sudo sed -i '/^MODULES=(intel_agp i915 nouveau)$/ s/^/#/' /etc/mkinitcpio.conf
    sudo sed -i '/^MODULES=(intel_agp i915 nvidia nvidia_modeset nvidia_uvm nvidia_drm)$/ s/^/#/' /etc/mkinitcpio.conf
    sudo sed -i '/^#MODULES=(intel_agp i915)$/ s/^#//' /etc/mkinitcpio.conf
    sudo mkinitcpio -P

    if [[ -e $F_NV_HOOK ]]; then
        sudo mv $F_NV_HOOK $F_NV_HOOK.backup
    fi
}

# to get PRIME work with nouveau, xf86-video-nouveau must be installed
function use_nouveau {
    sudo cp $F_X11_CONF.nouveau $F_X11_CONF

    if [[ -e $F_NV_OUTPUTCLASS ]]; then
        sudo mv $F_NV_OUTPUTCLASS $F_NV_OUTPUTCLASS.backup
    fi

    # do not poweroff nvidia GPU
    sudo systemctl disable disable_nvidia.service

    # blacklist nvidia
    if [[ -e $F_NVIDIA_BLACKLIST.backup ]]; then
        sudo mv $F_NVIDIA_BLACKLIST.backup $F_NVIDIA_BLACKLIST
    fi

    # remove nouveau from blacklist
    if [[ -e $F_NOUVEAU_BLACKLIST ]]; then
        sudo mv $F_NOUVEAU_BLACKLIST $F_NOUVEAU_BLACKLIST.backup
    fi

    # comment out all PRIME settings
    sed -i '/^xrandr --set/ s/^/#/' ~/.xinitrc
    # enable reverse PRIME for nouveau
    sed -i '/^#xrandr --setprovideroutputsource modesetting nouveau/ s/^#//' ~/.xinitrc

    # setup display
    # comment out nvidia setting
    sed -i '/^xrandr --output eDP-1-1/ s/^/#/' ~/.xinitrc
    # comment out intel setting
    sed -i '/^xrandr --auto --dpi 144/ s/^/#/' ~/.xinitrc
    # uncomment nouveau setting
    sed -i '/^#xrandr --output eDP1/ s/^#//' ~/.xinitrc
    sed -i '/^#xrandr --output HDMI/ s/^#//' ~/.xinitrc

    # fix kernel modules
    sudo sed -i '/^#MODULES=(intel_agp i915 nouveau)$/ s/^#//' /etc/mkinitcpio.conf
    sudo sed -i '/^MODULES=(intel_agp i915 nvidia nvidia_modeset nvidia_uvm nvidia_drm)$/ s/^/#/' /etc/mkinitcpio.conf
    sudo sed -i '/^MODULES=(intel_agp i915)$/ s/^/#/' /etc/mkinitcpio.conf
    sudo mkinitcpio -P

    if [[ -e $F_NV_HOOK ]]; then
        sudo mv $F_NV_HOOK $F_NV_HOOK.backup
    fi
}

if [[ $1 == "nvidia" ]]; then
    use_nvidia
elif [[ $1 == "intel" ]]; then
    use_intel
elif [[ $1 == "nouveau" ]]; then
    use_nouveau
else
    echo "Invalid arguments"
    exit 1
fi
