#!/bin/bash

set -eEuo pipefail
error_exit() {
    s=$?
    echo "$0: Error on line $LINENO: $BASH_COMMAND"
    exit $s
}
trap error_exit ERR

sudo pacman -Syu --needed base-devel git

# dotfiles
mkdir -p "$HOME"/.config
git clone --bare https://github.com/h3fang/dotfiles "$HOME"/.config/dotfiles
# Be careful! This will overwrite existing files.
/usr/bin/git --git-dir="$HOME"/.config/dotfiles/ --work-tree="$HOME" checkout -f

# AUR helper
cd /tmp
git clone https://aur.archlinux.org/yay-bin.git --depth=1
cd yay-bin
makepkg -fsric

pacman="pacman-contrib rebuild-detector"
shell="zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions"
fonts="ttf-hack-nerd ttf-roboto ttf-nerd-fonts-symbols-mono otf-font-awesome noto-fonts noto-fonts-cjk noto-fonts-emoji"
drivers="mesa libva-mesa-driver vulkan-radeon"
audio="pipewire pipewire-pulse pipewire-alsa wireplumber"
system_tools="htop fd ncdu zip unzip zstd unrar p7zip file-roller openblas blas-openblas poppler-data man-db man-pages exa bat ripgrep gnome-keyring neofetch borg python-llfuse polkit-gnome earlyoom systembus-notify neovim tlp duf dog trash-cli"
multimedia="mpv gimp inkscape blender"
network="iwd transmission-gtk firefox openssh openbsd-netcat rclone rsync"
#i3="xorg-server xorg-xinit xorg-xrandr xorg-xinput xorg-xset xorg-xprop i3-wm i3blocks i3lock-color picom feh xss-lock dunst lxappearance-gtk3 papirus-icon-theme python-requests acpi jq maim python-i3ipc xclip"
sway="sway xorg-server-xwayland swaybg swayidle swaylock-effects-git waybar rofi-lbonn-wayland feh dunst lxappearance-gtk3 papirus-icon-theme wl-clipboard wf-recorder grim slurp python-requests acpi jq"
de_tools="xfce4-terminal thunar thunar-volman thunar-archive-plugin gvfs udiskie brightnessctl fzf"
im="fcitx5 fcitx5-qt fcitx5-gtk fcitx5-chinese-addons fcitx5-pinyin-zhwiki"
latex="texlive-meta texlive-langchinese biber"
programming="python pyright clang gdb cmake rustup mold tokei cargo-cache cargo-watch cargo-flamegraph visual-studio-code-bin godot"
academic="zotero-bin"

yay -S --needed "$pacman $shell $fonts $drivers $audio $system_tools $multimedia $network $sway $de_tools $im $latex $programming $academic"

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

# backup services
systemctl enable --now --user backup_data.timer
systemctl enable --now --user backup_zotero.timer
sudo systemctl enable --now backup_system.timer

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

