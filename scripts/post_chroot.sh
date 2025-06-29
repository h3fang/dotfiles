#!/bin/bash

set -eEuo pipefail
failure() {
    echo "line: $1 command: $2"
    exit "$3"
}
trap 'failure ${LINENO} "$BASH_COMMAND" $?' ERR

sudo pacman -Syu --needed base-devel git

# makepkg.conf
sudo sed -i 's/^#MAKEFLAGS=.*/MAKEFLAGS="-j$(nproc)"/' /etc/makepkg.conf
sudo sed -i 's/\sdebug\s/ !debug /' /etc/makepkg.conf
sudo sed -i 's/^#PACKAGER=.*/PACKAGER="hefang hf.enigma@gmail.com"/' /etc/makepkg.conf

# dotfiles
dotfiles="$HOME/.config/dotfiles"
if [ ! -d "$dotfiles" ]; then
    mkdir -p "$HOME/.config"
    git clone --bare https://github.com/h3fang/dotfiles "$dotfiles"
    # Be careful! This will overwrite existing files.
    git --git-dir="$dotfiles" --work-tree="$HOME" checkout -f
fi

# AUR helper
if ! pacman -Q yay-bin > /dev/null ; then
    cd /tmp
    git clone https://aur.archlinux.org/yay-bin.git --depth=1
    cd yay-bin
    makepkg -fsric
    cd
    rm -rf /tmp/yay-bin
fi

# at-spi2
grep -qxF "NO_AT_BRIDGE=1" /etc/environment || echo 'NO_AT_BRIDGE=1' | sudo tee -a /etc/environment

# pacman

sudo sed -i 's/^#IgnoreGroup =/IgnoreGroup = modified/' /etc/pacman.conf
sudo sed -i 's/^#Color$/Color/' /etc/pacman.conf
sudo sed -i 's/^#VerbosePkgLists$/VerbosePkgLists/' /etc/pacman.conf

no_extract=(
    "NoExtract = usr/lib/at-spi-bus-launcher"
    "NoExtract = etc/xdg/autostart/at-spi-dbus-bus.desktop"
    "NoExtract = usr/lib/systemd/user/at-spi-dbus-bus.service"
    "NoExtract = usr/share/dbus-1/services/org.a11y.*"
)

if grep -qxF "${no_extract[0]}" /etc/pacman.conf ; then 
    for f in "${no_extract[@]}"; do
        sudo sed -i -E "\\|#NoExtract\\s+=|a ${f}" /etc/pacman.conf
    done
fi

sudo mkdir -p /etc/pacman.d/hooks
sudo tee /etc/pacman.d/hooks/notify-orphans.hook > /dev/null <<EOF
[Trigger]
Operation = Upgrade
Operation = Remove
Type = Package
Target = *
[Action]
Depends = bash
Depends = systembus-notify
Depends = libnotify
When = PostTransaction
Exec = /usr/bin/bash -c 'PAC_QTD=\$(pacman -Qttd); if [[ -n "\$PAC_QTD" ]]; then printf "\033[1;33m\${PAC_QTD}\033[0m"; dbus-send --system / net.nuetzlich.SystemNotifications.Notify "string:Unused packages" "string:\$PAC_QTD"; fi'
EOF

sudo tee /etc/pacman.d/hooks/notify-pacnew-and-pacsave.hook > /dev/null <<EOF
[Trigger]
Operation = Install
Operation = Upgrade
Operation = Remove
Type = Package
Target = *
[Action]
Depends = bash
Depends = fd
Depends = systembus-notify
Depends = libnotify
When = PostTransaction
Exec = /usr/bin/bash -c 'PAC_DIFF=\$(pacdiff -o); if [[ -n "\$PAC_DIFF" ]]; then printf "\033[1;33m\${PAC_DIFF}\033[0m"; dbus-send --system / net.nuetzlich.SystemNotifications.Notify "string:New pacnew/pacsave files" "string:\$PAC_DIFF"; fi'
EOF

sudo tee /etc/pacman.d/hooks/stop-wine-associations.hook > /dev/null <<EOF
[Trigger]
Type = Path
Operation = Install
Operation = Upgrade
Target = usr/share/wine/wine.inf

[Action]
Description = Stopping Wine from hijacking file associations...
When = PostTransaction
Exec = /usr/bin/sed -i 's/winemenubuilder.exe -a -r/winemenubuilder.exe -r/g' /usr/share/wine/wine.inf
EOF

sudo tee /etc/pacman.d/hooks/update-wm-bars.hook > /dev/null <<EOF
[Trigger]
Operation = Install
Operation = Upgrade
Operation = Remove
Type = Package
Target = *
[Action]
Depends = procps-ng
When = PostTransaction
Exec = /usr/bin/pkill -SIGRTMIN+2 waybar
EOF

# pacakges

echo 'GPU'
select gpu in "amd" "intel" "nvidia" ; do
    case "$gpu" in
        "amd" ) sudo pacman -S --needed linux-firmware-amdgpu mesa vulkan-radeon; break ;;
        "intel" ) sudo pacman -S --needed linux-firmware-intel mesa vulkan-intel intel-media-driver; break ;;
        "nvidia" ) sudo pacman -S --needed linux-firmware-nvidia nvidia-open-dkms nvidia-utils; break ;;
    esac
done

sudo pacman -S --needed linux-firmware-realtek linux-firmware-cirrus linux-firmware-other linux-firmware-intel sof-firmware \
    pacman-contrib rebuild-detector \
    zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions fzf starship alacritty \
    ttf-hack-nerd ttf-roboto ttf-nerd-fonts-symbols-mono otf-font-awesome noto-fonts noto-fonts-cjk noto-fonts-emoji \
    pipewire pipewire-pulse wireplumber \
    zip unzip unrar 7zip file-roller \
    htop fd ncdu man-db man-pages eza bat ripgrep gnome-keyring fastfetch borg polkit-gnome systembus-notify duf dog trash-cli \
    openblas blas-openblas \
    mpv loupe evince poppler-data typst \
    transmission-gtk firefox profile-cleaner openssh openbsd-netcat rclone rsync \
    sway xorg-xwayland swaybg swayidle swaylock xdg-desktop-portal xdg-desktop-portal-wlr \
    waybar python-requests rofi-wayland dunst papirus-icon-theme wl-clipboard wf-recorder grim slurp satty acpi jq \
    thunar thunar-volman gvfs udiskie brightnessctl \
    fcitx5 fcitx5-qt fcitx5-gtk fcitx5-chinese-addons fcitx5-pinyin-zhwiki \
    python clang gdb cmake rustup mold tokei cargo-outdated nodejs
yay -S --needed visual-studio-code-bin # zotero-bin

# self-maintained AUR packages

mkdir -p ~/projects
if [[ ! -d ~/projects/AUR ]]; then
    git clone git@github.com:h3fang/AUR.git ~/projects/AUR
fi
if ! command -v pf >/dev/null 2>&1; then
    cd ~/projects/AUR/pacfilter
    makepkg -fsric
fi

# kernel modules
echo 'blacklist pcspkr' | sudo tee /etc/modprobe.d/nobeep.conf
sudo rmmod pcspkr || true

# backup services
#systemctl enable --now --user backup_data.timer
#systemctl enable --now --user backup_zotero.timer
#sudo systemctl enable --now backup_system.timer

# gnome-keyring and ssh keys
if ! grep -q "auth       optional     pam_gnome_keyring.so" /etc/pam.d/login; then
    sudo sed -i '/auth       include      system-local-login/a auth       optional     pam_gnome_keyring.so' /etc/pam.d/login
fi

if ! grep -q "session    optional     pam_gnome_keyring.so auto_start" /etc/pam.d/login; then
    sudo sed -i '/session    include      system-local-login/a session    optional     pam_gnome_keyring.so auto_start' /etc/pam.d/login
fi

if ! grep -q "password   optional     pam_gnome_keyring.so" /etc/pam.d/login; then
    sudo sed -i '/password   include      system-local-login/a password   optional     pam_gnome_keyring.so' /etc/pam.d/login
fi
systemctl --user enable --now gcr-ssh-agent.socket

# mask systemd components
sudo systemctl mask systemd-homed.service systemd-journald-audit.socket

# tlp
#sudo systemctl enable --now tlp.service
#sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket

# systemd-netowrkd

sudo tee /etc/systemd/network/20-wired.network > /dev/null <<EOF
[Match]
Name=en*

[Link]
RequiredForOnline=routable

[Network]
DHCP=yes
EOF

sudo tee /etc/systemd/network/25-wireless.network > /dev/null <<EOF
[Match]
Name=wl*

[Link]
RequiredForOnline=routable

[Network]
DHCP=yes
IgnoreCarrierLoss=3s
EOF

sudo mkdir -p /etc/systemd/system/systemd-networkd-wait-online.service.d
sudo tee /etc/systemd/system/systemd-networkd-wait-online.service.d/wait-for-any.conf > /dev/null <<EOF
[Service]
ExecStart=/usr/lib/systemd/systemd-networkd-wait-online --any
EOF

sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
sudo systemctl enable systemd-networkd.service systemd-resolved.service

# disable gvfs automount for network
sudo sed -i 's/^AutoMount=true$/AutoMount=false/' /usr/share/gvfs/mounts/network.mount || true

# increase evince cache size
gsettings set org.gnome.Evince page-cache-size 128

# disable "recently used" in file manager
gsettings set org.gnome.desktop.privacy remember-recent-files false

# set default terminal
gsettings set org.gnome.desktop.default-applications.terminal exec alacritty

