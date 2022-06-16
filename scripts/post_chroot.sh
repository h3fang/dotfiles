#!/bin/bash

set -eEuo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

sudo pacman -Syu --needed base-devel git

# dotfiles
mkdir -p $HOME/.config
git clone --bare https://github.com/h3fang/dotfiles $HOME/.config/dotfiles
# Be careful! This will overwrite existing files.
/usr/bin/git --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME checkout -f

# AUR helper
cd /tmp
git clone https://aur.archlinux.org/yay-bin.git --depth=1
cd yay-bin
makepkg -fsric

fonts="ttf-hack ttf-roboto ttf-nerd-fonts-symbols-mono otf-font-awesome noto-fonts noto-fonts-cjk noto-fonts-emoji"
drivers="mesa libva-mesa-driver vulkan-radeon pulseaudio"
system_tools="htop fd ncdu zip unzip zstd unrar p7zip file-roller openblas poppler-data man-db man-pages exa bat ntfs-3g gnome-keyring neofetch borg python-llfuse polkit-gnome earlyoom systembus-notify neovim tlp bash-completion duf dog"
multimedia="mpv gimp inkscape blender"
network="transmission-gtk youtube-dl firefox openssh openbsd-netcat rclone rsync"
i3="xorg-server xorg-xinit xorg-xrandr xorg-xinput xorg-xset xorg-xprop i3-wm i3blocks i3lock-color picom feh xss-lock dunst lxappearance papirus-icon-theme python-requests acpi jq maim python-i3ipc xclip"
sway="sway xorg-server-xwayland swaybg swayidle swaylock-effects-git i3blocks feh dunst lxappearance papirus-icon-theme wl-clipboard wf-recorder grim slurp python-requests acpi jq"
de_tools="xfce4-terminal alacritty thunar thunar-volman thunar-archive-plugin gvfs udiskie rofi brightnessctl fzf"
im="fcitx5 fcitx5-qt fcitx5-gtk fcitx5-chinese-addons fcitx5-pinyin-zhwiki"
latex="texlive-bibtexextra texlive-core texlive-formatsextra texlive-humanities texlive-langchinese texlive-latexextra texlive-pictures texlive-pstricks texlive-publishers texlive-science biber"
programming="python clang gdb cmake rustup mold tokei cargo-watch cargo-flamegraph visual-studio-code-bin godot"
academic="zotero-bin"

yay -S --needed "$fonts $drivers $system_tools $multimedia $network $sway $de_tools $im $latex $programming $academic"

### self-maintained AUR packages
mkdir -p ~/projects
cd ~/projects
git clone https://github.com/h3fang/AUR.git
cd AUR
for package_dir in gammastep libblockdev evince; do
    cd $package_dir
    PKGEXT=.pkg.tar makepkg -fsri
    cd ..
done

### post-install configuration

# kernel modules
echo -e 'blacklist btusb\nblacklist bluetooth' | sudo tee /etc/modprobe.d/bluetooth.conf
echo 'blacklist uvcvideo' | sudo tee /etc/modprobe.d/camera.conf
echo 'blacklist pcspkr' | sudo tee /etc/modprobe.d/nobeep.conf
sudo rmmod pcspkr || true

# at-spi2
grep -qxF "NO_AT_BRIDGE=1" /etc/environment || echo 'NO_AT_BRIDGE=1' | sudo tee -a /etc/environment
sudo sed -i '/NoExtract/a NoExtract  = etc\/xdg\/autostart\/at-spi-dbus-bus.desktop usr\/lib\/at-spi-bus-launcher usr\/lib\/systemd\/user\/at-spi-dbus-bus.service' /etc/pacman.conf
sudo sed -i '/NoExtract/a NoExtract  = usr\/share\/dbus-1\/services\/org.a11y.*' /etc/pacman.conf

# dunst
sudo sed -i '/NoExtract/a NoExtract  = usr\/lib\/systemd\/user\/dunst.service usr\/share\/dbus-1\/services\/org.knopwob.dunst.service' /etc/pacman.conf

# earlyoom
sudo systemctl enable --now earlyoom.service

# user backup service
systemctl enable --now --user backup_data.timer
systemctl enable --now --user backup_zotero.timer

# mask useless gvfs components
# sudo systemctl mask gvfs-daemon.service || true
# sudo systemctl mask gvfs-metadata.service || true

# mask systemd components
sudo systemctl mask systemd-homed.service systemd-journald-audit.socket

# tlp
sudo systemctl enable --now tlp.service
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket

# disable gvfs automount for network
sudo sed -i 's/^AutoMount=true$/AutoMount=false/' /usr/share/gvfs/mounts/network.mount || true

# increase evince cache size
gsettings set org.gnome.Evince page-cache-size 128

# enable doulble tap as click
sudo tee /etc/X11/xorg.conf.d/30-touchpad.conf <<EOF
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
EndSection
EOF

