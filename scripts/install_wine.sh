#!/bin/bash

set -eEuo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

# should be fine if it is already enabled
sudo sed -i 's/^#\[multilib\]$/\[multilib\]/' /etc/pacman.conf
sudo sed -i '/^\[multilib\]$/{n; s/^#Include = \/etc\/pacman.d\/mirrorlist$/Include = \/etc\/pacman.d\/mirrorlist/}' /etc/pacman.conf

# update first to fetch multilib database
sudo pacman -Syu

wine="wine-staging"
dxvk="dxvk-bin"
graphics_driver=lib32-mesa
yay -S --needed $wine wine-gecko wine-mono winetricks $dxvk $graphics_driver lib32-giflib lib32-libpng lib32-libldap lib32-gnutls lib32-mpg123 lib32-openal lib32-v4l-utils lib32-libpulse lib32-libgpg-error lib32-alsa-plugins lib32-alsa-lib lib32-libjpeg-turbo lib32-sqlite lib32-libxcomposite lib32-libgcrypt lib32-libxinerama lib32-ncurses ocl-icd lib32-ocl-icd lib32-libxslt lib32-libva lib32-gtk3 lib32-gst-plugins-base-libs lib32-vulkan-icd-loader

# initialize wine prefix
wineboot -u
if pgrep wineboot; then
    tail --pid=$(pgrep wineboot) -f /dev/null
fi
if pgrep wineserver; then
    tail --pid=$(pgrep wineserver) -f /dev/null
fi
sleep 3
# dxvk
setup_dxvk install --symlink
