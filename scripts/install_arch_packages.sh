#!/bin/bash

sudo pacman -Syu base-devel git

# dotfiles
cd /tmp
git clone git@github.com:h3fang/dotfiles.git
rm -rf dotfiles/.git
mv dotfiles/* ~

# AUR helper
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
PKGEXT=.pkg.tar makepkg -sri

# fonts
yay -S ttf-dejavu ttf-liberation ttf-hack otf-font-awesome noto-fonts-cjk noto-fonts-emoji

# drivers
yay -S mesa pulseaudio
z
# system tools
yay -S htop gvim gedit fuseiso zip unzip unrar p7zip file-roller ntfs-3g openssh poppler-data mpv gimp

# network
yay -S networkmanager dhclient ppp transmission-qt youtube-dl chromium

# xorg
yay -S xorg-server xorg-xinit xorg-xrandr xorg-xinput xorg-xset xorg-xprop

# Latex
yay -S texlive-bibtexextra texlive-core texlive-formatsextra texlive-humanities texlive-langchinese texlive-latexextra texlive-pictures texlive-pstricks texlive-publishers texlive-science biber

# programming
yay -S python clang gdb cmake visual-studio-code-bin

# i3
yay -S i3-wm i3blocks i3lock numlockx xfce4-terminal thunar thunar-volman gvfs rofi compton feh xss-lock brightnessctl

# academic
yay -S zotero
