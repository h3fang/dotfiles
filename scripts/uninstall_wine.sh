#!/bin/bash

set -e

yay -Rns $(pacman -Qq wine dxvk lib32-nvidia-utils) lib32-giflib lib32-libpng lib32-libldap lib32-gnutls lib32-mpg123 lib32-openal lib32-v4l-utils lib32-libpulse lib32-libgpg-error lib32-alsa-plugins lib32-alsa-lib lib32-libjpeg-turbo lib32-sqlite lib32-libxcomposite lib32-libgcrypt lib32-libxinerama lib32-ncurses ocl-icd lib32-ocl-icd lib32-libxslt lib32-libva lib32-gtk3 lib32-gst-plugins-base-libs lib32-vulkan-icd-loader

read -p "Disable multilib? y/[n]" -n 1

if [[ $REPLY == "y" ]]; then
    sudo sed -i 's/^\[multilib\]$/#\[multilib\]/' /etc/pacman.conf
    sudo sed -i '/^#\[multilib\]$/{n; s/^Include = \/etc\/pacman.d\/mirrorlist$/#Include = \/etc\/pacman.d\/mirrorlist/}' /etc/pacman.conf
fi

# delete wine related
rm -rf $WINEPREFIX ~/.cache/winetricks
rm -r ~/.config/menus
rm -r ~/.local/share/applications
rm -r ~/.local/share/icons
rm -r ~/.local/share/mime
