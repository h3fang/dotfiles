#!/bin/bash

sudo pacman -Rns steam lib32-nvidia-utils

sudo sed -i 's/^\[multilib\]$/#\[multilib\]/; n; s/^Include = \/etc\/pacman.d\/mirrorlist$/#Include = \/etc\/pacman.d\/mirrorlist/' /etc/pacman.conf

sudo pacman -Syyu

rm -rf ~/.local/share/{Steam,vulkan} ~/.steam* ~/.pulse-cookie
