#!/bin/bash

sudo pacman -Rns steam lib32-nvidia-utils

read -p "Disable multilib? y/[n]" -n 1

if [[ $REPLY == "y" ]]; then
    sudo sed -i 's/^\[multilib\]$/#\[multilib\]/' /etc/pacman.conf
    sudo sed -i '/^#\[multilib\]$/{n; s/^Include = \/etc\/pacman.d\/mirrorlist$/#Include = \/etc\/pacman.d\/mirrorlist/}' /etc/pacman.conf
fi

rm -rf ~/.local/share/{Steam,vulkan} ~/.steam* ~/.pulse-cookie
