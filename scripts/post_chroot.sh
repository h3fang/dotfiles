#!/bin/bash

set -eEuo pipefail
failure() {
    echo "line: $1 command: $2"
    exit $3
}
trap 'failure ${LINENO} "$BASH_COMMAND" $?' ERR

sudo pacman -Syu --needed base-devel git git-delta

# dotfiles
mkdir -p "$HOME"/.config
git clone --bare https://github.com/h3fang/dotfiles "$HOME"/.config/dotfiles
# Be careful! This will overwrite existing files.
git --git-dir="$HOME"/.config/dotfiles/ --work-tree="$HOME" checkout -f

# AUR helper
cd /tmp
git clone https://aur.archlinux.org/yay-bin.git --depth=1
cd yay-bin
makepkg -fsric

# at-spi2
grep -qxF "NO_AT_BRIDGE=1" /etc/environment || echo 'NO_AT_BRIDGE=1' | sudo tee -a /etc/environment
sudo sed -i -E '|#NoExtract\s+=|a NoExtract  = usr/lib/at-spi-bus-launcher' /etc/pacman.conf
sudo sed -i -E '|#NoExtract\s+=|a NoExtract  = etc/xdg/autostart/at-spi-dbus-bus.desktop' /etc/pacman.conf
sudo sed -i -E '|#NoExtract\s+=|a NoExtract  = usr/lib/systemd/user/at-spi-dbus-bus.service' /etc/pacman.conf
sudo sed -i -E '|#NoExtract\s+=|a NoExtract  = usr/share/dbus-1/services/org.a11y.*' /etc/pacman.conf

# dunst
sudo sed -i -E '|#NoExtract\s+=|a NoExtract  = usr/lib/systemd/user/dunst.service' /etc/pacman.conf
sudo sed -i -E '|#NoExtract\s+=|a NoExtract  = usr/share/dbus-1/services/org.knopwob.dunst.service' /etc/pacman.conf

pacman="pacman-contrib rebuild-detector"
shell="zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions"
fonts="ttf-hack-nerd ttf-roboto ttf-nerd-fonts-symbols-mono otf-font-awesome noto-fonts noto-fonts-cjk noto-fonts-emoji"
drivers="mesa mesa-vdpau vulkan-radeon"
audio="pipewire pipewire-pulse wireplumber"
system_tools="htop fd ncdu unrar 7zip file-roller openblas blas-openblas poppler-data man-db man-pages eza bat ripgrep gnome-keyring fastfetch borg python-llfuse polkit-gnome systembus-notify neovim duf dog trash-cli"
multimedia="mpv loupe gimp inkscape blender"
network="transmission-gtk firefox profile-cleaner openssh openbsd-netcat rclone rsync"
sway="sway xorg-xwayland swaybg swayidle waybar rofi-wayland dunst papirus-icon-theme wl-clipboard wf-recorder grim slurp satty python-requests acpi jq"
de_tools="alacritty thunar thunar-volman gvfs udiskie brightnessctl fzf"
im="fcitx5 fcitx5-qt fcitx5-gtk fcitx5-chinese-addons fcitx5-pinyin-zhwiki"
latex="texlive-meta texlive-langchinese biber"
programming="python clang gdb cmake rustup mold tokei cargo-cache cargo-outdated visual-studio-code-bin godot"
academic="zotero-bin"

yay -S --needed "$pacman $shell $fonts $drivers $audio $system_tools $multimedia $network $sway $de_tools $im $latex $programming $academic"


### self-maintained AUR packages
mkdir -p ~/projects
cd ~/projects

### post-install configuration

# kernel modules
#echo -e 'blacklist btusb\nblacklist bluetooth' | sudo tee /etc/modprobe.d/bluetooth.conf
#echo 'blacklist uvcvideo' | sudo tee /etc/modprobe.d/camera.conf
echo 'blacklist pcspkr' | sudo tee /etc/modprobe.d/nobeep.conf
sudo rmmod pcspkr || true

# backup services
#systemctl enable --now --user backup_data.timer
#systemctl enable --now --user backup_zotero.timer
#sudo systemctl enable --now backup_system.timer

# mask systemd components
sudo systemctl mask systemd-homed.service systemd-journald-audit.socket

# tlp
#sudo systemctl enable --now tlp.service
#sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket

# disable gvfs automount for network
sudo sed -i 's/^AutoMount=true$/AutoMount=false/' /usr/share/gvfs/mounts/network.mount || true

# increase evince cache size
gsettings set org.gnome.Evince page-cache-size 128

# disable "recently used" in file manager
gsettings set org.gnome.desktop.privacy remember-recent-files false

# set default terminal
gsettings set org.gnome.desktop.default-applications.terminal exec alacritty

