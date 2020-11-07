#!/bin/bash

set -eEuo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

sudo pacman -Syu --needed base-devel git bash-completion

# dotfiles
mkdir $HOME/.config
git clone --bare https://github.com/h3fang/dotfiles $HOME/.config/dotfiles
/usr/bin/git --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME checkout

# AUR helper
cd /tmp
git clone https://aur.archlinux.org/yay-bin.git --depth=1
cd yay-bin
makepkg -fsri

# fonts
yay -S ttf-hack ttf-roboto ttf-nerd-fonts-symbols-mono noto-fonts noto-fonts-cjk noto-fonts-emoji

# drivers
yay -S mesa libva-mesa-driver vulkan-radeon pulseaudio

# system tools
yay -S --needed htop fd ncdu zip unzip zstd unrar p7zip file-roller openblas poppler-data man-db man-pages exa bat ntfs-3g
yay -S gnome-keyring neofetch borg python-llfuse polkit-gnome
yay -S earlyooom systembus-notify
yay -S gvim vim-airline

# multimedia
yay -S mpv gimp inkscape

# network
yay -S transmission-gtk youtube-dl chromium openssh openbsd-netcat rclone rsync

# DE/WM
echo 'Install i3?'
select yn in "y" "n"; do
    case $yn in
        y)
            yay -S --needed xorg-server xorg-xinit xorg-xrandr xorg-xinput xorg-xset xorg-xprop \
                i3-wm i3blocks i3lock-color \
                picom feh xss-lock dunst lxappearance-gtk3 papirus-icon-theme gammastep \
                python-requests acpi jq flameshot maim python-i3ipc xclip
            break;;
        n)  break;;
    esac
done
G
echo 'Install sway?'
select yn in "y" "n"; do
    case $yn in
        y)
            yay -S --needed sway xorg-server-xwayland swaybg swayidle swaylock-effects-git i3blocks \
                feh xss-lock dunst lxappearance-gtk3 papirus-icon-theme gammastep \
                wl-clipboard grim slurp python-requests acpi jq
            break;;
        n)  break;;
    esac
done

yay -S --needed xfce4-terminal thunar thunar-volman thunar-archive-plugin gvfs udiskie rofi brightnessctl fzf
yay -S --nedded fcitx5 fcitx5-qt fcitx5-gtk fcitx5-chinese-addons fcitx5-pinyin-zhwiki

# Latex
yay -S --needed texlive-bibtexextra texlive-core texlive-formatsextra texlive-humanities texlive-langchinese texlive-latexextra texlive-pictures texlive-pstricks texlive-publishers texlive-science biber

# programming
yay -S --needed python clang gdb cmake code

# academic
yay -S zotero

### self-maintained AUR packages
mkdir -p ~/projects
cd ~/projects
git clone https://github.com/h3fang/AUR.git
cd AUR
for package_dir in qpdfview libblockdev evince-light hstr-git; do
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

# earlyoom
sudo systemctl enable --now earlyoom.service

# user backup service
systemctl enable --now --user backup_borg.timer

# mask useless gvfs components
# sudo systemctl mask gvfs-daemon.service || true
# sudo systemctl mask gvfs-metadata.service || true

# disable gvfs automount for network
sudo sed -i 's/^AutoMount=true$/AutoMount=false/' /usr/share/gvfs/mounts/network.mount || true

# increase evince cache size
gsettings set org.gnome.Evince page-cache-size 128

# enable doulble tap as click
tee /etc/X11/xorg.conf.d/30-touchpad.conf <<EOF
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
EndSection
EOF

