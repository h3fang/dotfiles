#!/bin/sh

# update system first
sudo pacman -Syu

# update yay
# yay -S yay

# self-maintained packages
cd ~/projects/AUR
for pkg in $(yay -Qgq modified) ; do
    cd $pkg-h3f
    PKGEXT=.pkg.tar makepkg -fsricC
    cd ..
done

# AUR source packages
yay -S brightnessctl hstr-git wlroots-git sway-git swaybg-git swayidle-git swaylock-git

# AUR binary packages
# yay -S visual-studio-code-bin zotero
