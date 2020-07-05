#!/bin/bash

set -eEuo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

# should be fine if it is already enabled
sudo sed -i 's/^#\[multilib\]$/\[multilib\]/' /etc/pacman.conf
sudo sed -i '/^\[multilib\]$/{n; s/^#Include = \/etc\/pacman.d\/mirrorlist$/Include = \/etc\/pacman.d\/mirrorlist/}' /etc/pacman.conf

# update first to fetch multilib database
sudo pacman -Syu

wine="wine-staging"
dxvk="dxvk-bin" #dxvk-mingw
graphics_driver="lib32-nvidia-utils" #lib32-mesa
sudo yay -S --needed $wine $dxvk $graphics_driver lib32-giflib lib32-libpng lib32-libldap lib32-gnutls lib32-mpg123 lib32-openal lib32-v4l-utils lib32-libpulse lib32-libgpg-error lib32-alsa-plugins lib32-alsa-lib lib32-libjpeg-turbo lib32-sqlite lib32-libxcomposite lib32-libgcrypt lib32-libxinerama lib32-ncurses ocl-icd lib32-ocl-icd lib32-libxslt lib32-libva lib32-gtk3 lib32-gst-plugins-base-libs lib32-vulkan-icd-loader

# use wine prefix in ~/.cache/wine instead of default ~/.wine, this is also exported in ~/scripts/envs
export WINEPREFIX=~/.cache/wine
# initialize wine prefix
wineboot -u
tail --pid=$(pgrep wineboot) -f /dev/null
tail --pid=$(pgrep wineserver) -f /dev/null
sleep 3
# dxvk
setup_dxvk install --symlink
