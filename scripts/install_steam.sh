#!/bin/bash

sudo sed -i 's/^#\[multilib\]$/\[multilib\]/; n; s/^#Include = \/etc\/pacman.d\/mirrorlist$/Include = \/etc\/pacman.d\/mirrorlist/' /etc/pacman.conf
sudo pacman -Syyu
sudo pacman -S steam lib32-nvidia-utils
