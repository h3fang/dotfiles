#!/bin/sh

function use_nvidia
{
    sudo cp /etc/X11/xorg.conf.nvidia /etc/X11/xorg.conf

    outputclass="/usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf"
    if [ -e $outputclass.backup ]
    then
        sudo mv $outputclass.backup $outputclass
    fi

    # do not poweroff nvidia GPU
    sudo systemctl disable disable_nvidia.service

    # remove blacklist nvidia card conf
    sudo mv /usr/lib/modprobe.d/graphicscard.conf /usr/lib/modprobe.d/graphicscard.conf.backup

    # comment out all PRIME settings
    sed -i '/^xrandr --set/ s/^/#/' ~/.xinitrc
    # enable reverse PRIME for nvidia
    sed -i '/^#xrandr --setprovideroutputsource modesetting NVIDIA-0/ s/^#//' ~/.xinitrc

    # setup display
    # uncomment nvidia setting
    sed -i '/^#xrandr --output eDP-1/ s/^#//' ~/.xinitrc
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
    sudo mv /etc/pacman.d/hooks/nvidia.hook.backup /etc/pacman.d/hooks/nvidia.hook
}

function use_intel
{
    sudo cp /etc/X11/xorg.conf.intel /etc/X11/xorg.conf

    outputclass="/usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf"
    if [ -e $outputclass ]
    then
        sudo mv $outputclass $outputclass.backup
    fi

    # poweroff nvidia GPU
    sudo systemctl enable disable_nvidia.service

    # blacklist nvidia
    sudo mv /usr/lib/modprobe.d/graphicscard.conf.backup /usr/lib/modprobe.d/graphicscard.conf

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
    sudo mv /etc/pacman.d/hooks/nvidia.hook /etc/pacman.d/hooks/nvidia.hook.backup
}

# to get PRIME work with nouveau, xf86-video-nouveau must be installed
function use_nouveau
{
    sudo cp /etc/X11/xorg.conf.nouveau /etc/X11/xorg.conf

    outputclass="/usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf"
    if [ -e $outputclass ]
    then
        sudo mv $outputclass $outputclass.backup
    fi

    # do not poweroff nvidia GPU
    sudo systemctl disable disable_nvidia.service

    # blacklist nvidia
    sudo mv /usr/lib/modprobe.d/graphicscard.conf.backup /usr/lib/modprobe.d/graphicscard.conf
    # un-blacklist nouveau
    sudo mv /usr/lib/modprobe.d/nvidia.conf /usr/lib/modprobe.d/nvidia.conf.backup

    # comment out all PRIME settings
    sed -i '/^xrandr --set/ s/^/#/' ~/.xinitrc
    # enable reverse PRIME for nouveau
    sed -i '/^#xrandr --setprovideroutputsource modesetting nouveau/ s/^#//' ~/.xinitrc

    # setup display
    # comment out nvidia setting
    sed -i '/^xrandr --output eDP-1/ s/^/#/' ~/.xinitrc
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
    sudo mv /etc/pacman.d/hooks/nvidia.hook /etc/pacman.d/hooks/nvidia.hook.backup
}

