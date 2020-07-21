#!/bin/bash

set -eEuo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

sudo pacman -Syu --needed base-devel git

# dotfiles
cd /tmp
git clone git@github.com:h3fang/dotfiles.git
rm -rf dotfiles/.git
mv dotfiles/{.,}* $HOME/

# AUR helper
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
PKGEXT=.pkg.tar makepkg -fsri

# fonts
yay -S ttf-hack ttf-roboto otf-font-awesome noto-fonts noto-fonts-cjk noto-fonts-emoji

# drivers
yay -S mesa pulseaudio

# system tools
yay -S htop gvim fd ncdu zip unzip unrar p7zip file-roller openssh openblas poppler-data

# multimedia
yay -S mpv gimp inkscape

# network
yay -S netctl dhclient ppp sstp-client transmission-gtk youtube-dl chromium

# DE/WM
echo 'Install i3?'
select yn in "y" "n"; do
    case $yn in
        y)
            yay -S xorg-server xorg-xinit xorg-xrandr xorg-xinput xorg-xset xorg-xprop
            yay -S i3-wm i3blocks i3lock-color numlockx picom feh xss-lock
            break;;
        n)  break;;
    esac
done

echo 'Install sway?'
select yn in "y" "n"; do
    case $yn in
        y)
            yay -S sway xorg-server-xwayland swaybg swayidle swaylock-effects-git i3blocks
            break;;
        n)  break;;
    esac
done

yay -S xfce4-terminal thunar thunar-volman gvfs udiskie rofi brightnessctl

# Latex
yay -S texlive-bibtexextra texlive-core texlive-formatsextra texlive-humanities texlive-langchinese texlive-latexextra texlive-pictures texlive-pstricks texlive-publishers texlive-science biber

# programming
yay -S python clang gdb cmake code

# academic
yay -S zotero

### self-maintained AUR packages
cd ~/projects
git clone https://github.com/h3fang/AUR.git
cd AUR
for package_dir in notify-all qpdfview libblockdev; do
    cd $package_dir
    PKGEXT=.pkg.tar makepkg -fsri
    cd ..
done

### post-install configuration

# kernel modules
echo -e 'blacklist btusb\nblacklist bluetooth' | sudo tee /etc/modprobe.d/bluetooth.conf
echo 'blacklist uvcvideo' | sudo tee /etc/modprobe.d/camera.conf
echo 'blacklist pcspkr' | sudo tee /etc/modprobe.d/nobeep.conf
sudo rmmod pcspkr

# at-spi2
echo 'NO_AT_BRIDGE=1' | sudo tee -a /etc/environment
echo 'NoExtract = usr/share/dbus-1/services/org.a11y.*' | sudo tee -a /etc/pacman.conf

# adjust the log level for NetwokManager dhcp component, wpa_supplicant, doh-client
echo -e '[logging]\nlevel=WARN\ndomains=DHCP' | sudo tee /etc/NetworkManager/conf.d/dhcp-logging.conf > /dev/null
echo -e '[Service]\nLogLevelMax=notice' | sudo SYSTEMD_EDITOR=tee systemctl edit wpa_supplicant.service doh-client.service

# earlyoom (requires notify-all)
sudo sed -i 's|^EARLYOOM_ARGS=.*|EARLYOOM_ARGS="-m 5 -r 0 -N '/usr/bin/notify-all'"|' /etc/default/earlyoom

sudo systemctl enable --now earlyoom.service

# user backup service
systemctl enable --now --user backup_borg.timer

# mask useless gvfs components
sudo systemctl mask gvfs-daemon.service || true
sudo systemctl mask gvfs-metadata.service || true

# disable gvfs automount for network
sudo sed -i 's/^AutoMount=true$/AutoMount=false/' /usr/share/gvfs/mounts/network.mount || true

# increase evince cache size
gsettings set org.gnome.Evince page-cache-size 64
