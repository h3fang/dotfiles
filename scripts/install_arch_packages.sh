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
PKGEXT=.pkg.tar makepkg -fsri

# fonts
yay -S ttf-dejavu ttf-liberation ttf-hack ttf-roboto otf-font-awesome noto-fonts noto-fonts-cjk noto-fonts-emoji

# drivers
yay -S mesa pulseaudio

# system tools
yay -S htop gvim fd ncdu gedit fuseiso zip unzip unrar p7zip file-roller ntfs-3g openssh poppler-data mpv gimp

# network
yay -S networkmanager network-manager-applet dhclient ppp sstp-client transmission-qt youtube-dl chromium

# xorg
yay -S xorg-server xorg-xinit xorg-xrandr xorg-xinput xorg-xset xorg-xprop

# Latex
yay -S texlive-bibtexextra texlive-core texlive-formatsextra texlive-humanities texlive-langchinese texlive-latexextra texlive-pictures texlive-pstricks texlive-publishers texlive-science biber

# programming
yay -S python clang gdb cmake visual-studio-code-bin

# i3
yay -S i3-wm i3blocks i3lock-color numlockx xfce4-terminal thunar thunar-volman gvfs rofi compton feh xss-lock brightnessctl

# academic
yay -S zotero

### self-maintained AUR packages
cd ~/projects
git clone https://github.com/h3fang/AUR.git
cd AUR
for package_dir in $(fd -t d -d 1); do
    cd $package_dir
    PKGEXT=.pkg.tar makepkg -fsri
    cd ..
done

### post-install configuration
sudo systemctl enable now NetworkManager.service doh-client.service earlyoom.service

# adjust the log level for NetwokManager dhcp component, wpa_supplicant, doh-client
echo -e '[logging]\nlevel=WARN\ndomains=DHCP' | sudo tee /etc/NetworkManager/conf.d/dhcp-logging.conf > /dev/null
echo -e '[Service]\nLogLevelMax=4' | sudo SYSTEMD_EDITOR=tee systemctl edit wpa_supplicant.service doh-client.service

# earlyoom
sudo sed -i 's|^EARLYOOM_ARGS=.*|EARLYOOM_ARGS="-m 5 -r 0 -N '/usr/bin/notify-all'"|' /etc/default/earlyoom

# user backup service
systemctl enable --now --user backup_borg.timer
