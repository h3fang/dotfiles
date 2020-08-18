#!/bin/bash

set -e

# should be fine if it is already enabled
sudo sed -i 's/^#\[multilib\]$/\[multilib\]/' /etc/pacman.conf
sudo sed -i '/^\[multilib\]$/{n; s/^#Include = \/etc\/pacman.d\/mirrorlist$/Include = \/etc\/pacman.d\/mirrorlist/}' /etc/pacman.conf

sudo pacman -Syu --needed steam lib32-mesa lib32-vulkan-icd-loader lib32-vulkan-radeon
