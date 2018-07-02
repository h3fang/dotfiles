#!/bin/sh

sudo pacman -Syu

sudo pacman -S base-devel git 

# install pikaur
cd ~/Downloads
git clone https://aur.archlinux.org/aurman.git
cd aurman
makepkg -fsri

# fetch dotfiles
cd ~/Downloads
git clone git@github.com:h3fang/dotfiles.git
mv dotfiles/{,.[^.]}* ~

# install others
sudo aurman -S htop networkmanager ttf-dejavu ttf-liberation ttf-hack otf-font-awesome font-mathematica noto-fonts-cjk noto-fonts-emoji gvim chromium dhclient openssh lightdm lightdm-gtk-greeter numlockx mousepad evince xfce4-terminal thunar gvfs thunar-volman rofi compton feh xorg-server xorg-xrandr xorg-xinput xorg-xset mesa maim fuseiso zip unzip unrar p7zip file-roller ntfs-3g poppler-data xss-lock-git brightnessctl ppp transmission-qt youtube-dl pulseaudio mpv gimp valgrind python python-pip qt qtcreator gdb cmake texlive-most texlive-langchinese biber zotero openblas-lapack visual-studio-code-bin

