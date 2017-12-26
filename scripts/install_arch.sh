#!/bin/sh

sudo pacman -Syyu

sudo pacman -S base-devel git 

# install pacaur
cd ~/Downloads
git clone https://aur.archlinux.org/cower.git
cd cower
makepkg -si --needed

cd ~/Downloads
git clone https://aur.archlinux.org/pacaur.git
cd pacaur
makepkg -si --needed

# install blablabla
sudo pacaur -S htop networkmanager ttf-dejavu ttf-liberation ttf-hack ttf-font-awesome font-mathematica noto-fonts-cjk noto-fonts-emoji ttf-symbola gvim chromium dhclient openssh lightdm lightdm-gtk-greeter numlockx gedit evince xfce4-terminal thunar gvfs thunar-volman rofi compton feh xorg-server xorg-xrandr nvidia mesa acpi scrot fuseiso zip unzip unrar p7zip file-roller ntfs-3g poppler-data xss-lock-git brightnessctl ppp sstp-client transmission-qt youtube-dl pulseaudio mpv gimp atom valgrind python python-pip qt qtcreator gdb cmake texlive-most texlive-langchinese texlive-langgreek biber zotero wd719x-firmware aic94xx-firmware openblas-lapack

