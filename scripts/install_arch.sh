#!/bin/sh

sudo pacman -Syu

sudo pacman -S base-devel git 

# fetch dotfiles
cd ~/Downloads
git clone git@github.com:h3fang/dotfiles.git
mv dotfiles/* ~
rm -rf dotfiles/

# install AUR helper
cd ~/Downloads
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -sri

# install others
yay -S htop networkmanager ttf-dejavu ttf-liberation ttf-hack otf-font-awesome font-mathematica noto-fonts-cjk noto-fonts-emoji gvim chromium dhclient openssh numlockx gedit xfce4-terminal thunar thunar-volman rofi compton feh xorg-server xorg-xinit xorg-xrandr xorg-xinput xorg-xset mesa fuseiso zip unzip unrar p7zip file-roller ntfs-3g poppler-data xss-lock brightnessctl ppp transmission-qt youtube-dl pulseaudio mpv gimp python qt qtcreator gdb cmake texlive-most texlive-langchinese biber zotero visual-studio-code-bin

