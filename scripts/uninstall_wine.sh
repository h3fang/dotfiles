#!/bin/bash

yay -Rns wine-staging wine-gecko wine-mono lib32-nvidia-utils lib32-libpulse lib32-libxml2 lib32-mpg123 lib32-lcms2 lib32-giflib lib32-libpng lib32-gnutls lib32-libldap lib32-libgpg-error lib32-gst-plugins-base lib32-gst-plugins-good winetricks dxvk-bin

read -p "Disable multilib? y/[n]" -n 1

if [[ $REPLY == "y"]]; then
    sudo sed -i 's/^\[multilib\]$/#\[multilib\]/' /etc/pacman.conf
    sudo sed -i '/^#\[multilib\]$/{n; s/^Include = \/etc\/pacman.d\/mirrorlist$/#Include = \/etc\/pacman.d\/mirrorlist/}' /etc/pacman.conf
fi

# delete wine related
rm -rf $WINEPREFIX ~/.cache/winetricks
rm -f ~/.config/menus/applications-merged/wine-*
rm -rf ~/.local/share/applications/wine
rm -f ~/.local/share/icons/hicolor/*/*/application-x-wine-extension*
rm -f ~/.local/share/applications/mimeinfo.cache
rm -f ~/.local/share/mime/packages/x-wine*
rm -f ~/.local/share/mime/application/x-wine-extension*

# delete if empty
rmdir -p ~/.config/menus || true
rmdir -p ~/.local/share/{applications,icons,mime} || true
