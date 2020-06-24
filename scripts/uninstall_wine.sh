#!/bin/bash

yay -Rns dxvk-bin wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader

read -p "Disable multilib? y/[n]" -n 1

if [[ $REPLY == "y" ]]; then
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
