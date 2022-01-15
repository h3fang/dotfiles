#!/bin/bash
# requires borg, libsecret, libnotify, rclone, awk

set -eEuo pipefail
trap 's=$?; echo "$0: Error on line $LINENO"; notify-send "$0: Error on line $LINENO";  exit $s' ERR

O_BACKUP="ask"
O_PRUNE="ask"
O_SYNC="ask"

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --backup) O_BACKUP="yes"; shift;;
        --no-backup) O_BACKUP="no"; shift;;
        --prune) O_PRUNE="yes"; shift;;
        --no-prune) O_PRUNE="no"; shift;;
        --sync) O_SYNC="yes"; shift;;
        --no-sync) O_SYNC="no"; shift;;
        --) shift; break;;
        *) echo "Unknown option: $1"; exit 1;;
    esac
done

export BORG_REPO=$HOME/.local/share/backups/data
export BORG_PASSCOMMAND="secret-tool lookup borgrepo default"
REMOTE_DIR=arch-home-${USER}-$(awk '{print substr($0,1,6); exit}' /etc/machine-id)
RCLONE_REMOTE=('googledrive' 'onedrive' 'box')

function f_backup {
    borg create --compression auto,zstd,16 --stats --list --filter=AME \
        --exclude "$HOME/.config/blender/*/scripts/addons" \
        --exclude "$HOME/.config/borg/security" \
        --exclude "$HOME/.config/cef_user_data/Dictionaries" \
        --exclude "$HOME/.config/clash/*.mmdb" \
        --exclude "$HOME/.config/Code" \
        --exclude "$HOME/.config/Code - OSS" \
        --exclude "$HOME/.config/chromium" \
        --exclude "$HOME/.config/draw.io" \
        --exclude "$HOME/.config/Joplin" \
        --exclude "$HOME/.config/libreoffice" \
        --exclude "$HOME/.config/mpv/watch_later" \
        --exclude "$HOME/.config/GIMP" \
        --exclude "$HOME/.config/parallel/tmp" \
        --exclude "$HOME/.config/pulse" \
        --exclude "$HOME/.config/QtProject/qtcreator/qbs" \
        --exclude "$HOME/.config/QtProject/qtcreator/.helpcollection" \
        --exclude "$HOME/.config/fcitx5/conf/cached_layouts" \
        --exclude "$HOME/.config/ibus/bus" \
        --exclude "$HOME/.config/menus" \
        --exclude "$HOME/.config/transmission/resume" \
        --exclude "$HOME/.config/transmission/dht.dat" \
        --exclude "$HOME/.ssh/known_hosts" \
        --exclude "sh:$HOME/projects/**/build-*" \
        --exclude "sh:$HOME/projects/**/[bB]uild" \
        --exclude "sh:$HOME/projects/**/target" \
        --exclude "sh:$HOME/projects/**/[dD]ata" \
        --exclude "sh:$HOME/projects/**/assets" \
        --exclude "sh:$HOME/projects/**/[rR]esults" \
        --exclude "sh:$HOME/projects/**/.vscode/ipch" \
        --exclude "sh:$HOME/projects/**/.import" \
        --exclude "sh:$HOME/projects/**/node_modules" \
        --exclude "sh:$HOME/projects/**/*.so" \
        --exclude "sh:$HOME/projects/AUR/*/*.tar" \
        --exclude "sh:$HOME/projects/AUR/*/*.tar.gz" \
        --exclude "sh:$HOME/projects/AUR/*/*.tar.xz" \
        --exclude "sh:$HOME/projects/AUR/*/*.txz" \
        --exclude "sh:$HOME/projects/AUR/*/*.tar.bz2" \
        --exclude "sh:$HOME/projects/AUR/*/*.tar.zst" \
        --exclude "sh:$HOME/projects/AUR/*/*.zip" \
        --exclude "sh:$HOME/projects/AUR/*/*.AppImage" \
        --exclude "sh:$HOME/projects/AUR/*/*/*" \
        --exclude "sh:$HOME/projects/AUR/*/pkg" \
        --exclude "sh:$HOME/projects/AUR/*/src" \
        --exclude "sh:$HOME/projects/Courses/**/*.pdf" \
        --exclude "sh:$HOME/projects/Courses/**/*.npz" \
        --exclude "sh:$HOME/**/__pycache__" \
        --exclude "$HOME/projects/blog/public" \
        "::{now:%Y-%m-%d_%H-%M-%S}" \
        ~/.config \
        ~/.gnupg \
        ~/.local/share/bash-completion \
        ~/.local/share/fcitx5 \
        ~/.local/share/keyrings \
        ~/.local/share/systemd \
        ~/.ssh \
        ~/scripts \
        ~/Pictures \
        ~/projects \
        ~/Documents \
        ~/.bashrc \
        ~/.bash_profile \
        ~/.xinitrc \
        ~/.gitignore \
        /etc/pacman.d/hooks \
        /etc/pacman.d/mirrorlist \
        /etc/pacman.conf \
        /etc/iwd/main.conf \
        /etc/wpa_supplicant \
        /etc/mkinitcpio.d \
        /etc/mkinitcpio.conf \
        /etc/tlp.d \
        /etc/tlp.conf \
        /etc/sysctl.d \
        /etc/modprobe.d \
        /etc/modules-load.d \
        /etc/udev/rules.d \
        /etc/sway \
        /etc/systemd \
        /etc/smartdns \
        /etc/default/earlyoom \
        /etc/makepkg.conf \
        /etc/X11/xorg.conf.d \
        /etc/security/faillock.conf \
        /boot/loader/loader.conf \
        /boot/loader/entries

    # warn for abnormal delta size
    last_backup_info=$(borg info --last 1 | awk '/This archive:/{print}')
    last_size=$(echo "$last_backup_info" | awk '{print $7}')
    last_unit=$(echo "$last_backup_info" | awk '{print $8}')

    # anything other than "kB", including "MB", "GB", or possibly "B" (I dont't know the complete list of uints in borg backup)
    if [[ $last_unit != "kB" ]]; then
        # delta smaller than 2 MB is fine
        if ! [[ $last_unit == "MB" && $(echo "$last_size" "2.0" | awk '{if ($1 <= $2) print 1;}') -eq 1 ]]; then
            echo "Abnormal last backup size: $last_size $last_unit"
            notify-send -u critical "Abnormal last backup size: $last_size $last_unit"
            exit 2
        fi
    fi
}

function f_prune {
    borg prune -v --list --keep-within=10d --keep-daily=30 --keep-weekly=4 --keep-monthly=4 --save-space
}

function f_sync {
    for remote in "${RCLONE_REMOTE[@]}"; do
        echo -e "\nuploading to ${remote} ..."
        rclone --drive-use-trash=false sync "$BORG_REPO" "${remote}:${REMOTE_DIR}" --timeout=30s --fast-list --transfers=10
    done
}

function ask_user {
    if [[ $1 == "yes" ]]; then
        $3
    elif [[ $1 == "ask" ]]; then
        echo -e -n "\e[38;5;201m"
        echo -n "$2 (y/[n])"
        echo -e -n '\e[0;0m'
        read -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            $3
        fi
    fi
}

if [[ ! -d $BORG_REPO ]]; then
    echo "repo $BORG_REPO not initialized"
    exit 3
fi

ask_user $O_BACKUP "Create a new archive?" f_backup
ask_user $O_PRUNE "Prune archives?" f_prune
ask_user $O_SYNC "Sync to cloud storage?" f_sync

