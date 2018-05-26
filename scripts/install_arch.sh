#!/bin/sh

sudo pacman -Syyu

sudo pacman -S base-devel git 

# install pikaur
cd ~/Downloads
git clone https://aur.archlinux.org/pikaur.git
cd pikaur
makepkg -fsri

# install blablabla
sudo pikaur -S htop networkmanager ttf-dejavu ttf-liberation ttf-hack otf-font-awesome font-mathematica noto-fonts-cjk noto-fonts-emoji ttf-symbola gvim chromium dhclient openssh lightdm lightdm-gtk-greeter numlockx mousepad evince xfce4-terminal thunar gvfs thunar-volman rofi compton feh xorg-server xorg-xrandr mesa maim fuseiso zip unzip unrar p7zip file-roller ntfs-3g poppler-data xss-lock-git brightnessctl ppp transmission-qt youtube-dl pulseaudio mpv gimp valgrind python python-pip qt qtcreator gdb cmake texlive-most texlive-langchinese texlive-langgreek biber zotero openblas-lapack visual-studio-code-bin

