#!/bin/bash

set -e

echo "removing multilib packages ..."

sudo pacman -Rns $(paclist multilib | awk '{print $1}')

echo "\ndisabling multilib repository ..."

sudo sed -i 's/^\[multilib\]$/#\[multilib\]/' /etc/pacman.conf
sudo sed -i '/^#\[multilib\]$/{n; s/^Include = \/etc\/pacman.d\/mirrorlist$/#Include = \/etc\/pacman.d\/mirrorlist/}' /etc/pacman.conf

