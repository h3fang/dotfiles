#!/bin/bash
# requires borg, libnotify, rclone (already setup)

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

REPO=/home/$USER/backups
PREFIX=arch-$(cat /etc/machine-id | head -c 6)-${USER}-home
RCLONE_REMOTE=('googledrive' 'onedrive')

function f_backup {
    borg create --compression auto,zstd,16 --stats --list --filter=AME \
        --exclude "/home/$USER/.config/mpv/watch_later" \
        --exclude "/home/$USER/.config/Atom" \
        --exclude "/home/$USER/.config/borg/security" \
        --exclude "/home/$USER/.config/Code" \
        --exclude "/home/$USER/.config/Code - OSS" \
        --exclude "/home/$USER/.config/VSCodium" \
        --exclude "/home/$USER/.config/chromium" \
        --exclude "/home/$USER/.config/libreoffice" \
        --exclude "/home/$USER/.config/GIMP" \
        --exclude "/home/$USER/.config/pulse" \
        --exclude "/home/$USER/.config/QtProject/qtcreator/qbs" \
        --exclude "/home/$USER/.config/QtProject/qtcreator/.helpcollection" \
        --exclude "/home/$USER/.config/fcitx5/conf/cached_layouts" \
        --exclude "/home/$USER/.config/ibus/bus" \
        --exclude "/home/$USER/.config/menus" \
        --exclude "/home/$USER/.config/transmission/resume" \
        --exclude "/home/$USER/.config/transmission/dht.dat" \
        --exclude "sh:/home/$USER/.ssh/known_hosts" \
        --exclude "sh:/home/$USER/projects/**/[bB]uild" \
        --exclude "sh:/home/$USER/projects/**/[dD]ata" \
        --exclude "sh:/home/$USER/projects/**/[rR]esults" \
        --exclude "sh:/home/$USER/projects/**/.vscode/ipch" \
        --exclude "sh:/home/$USER/projects/AUR/*/*.tar.?z" \
        --exclude "sh:/home/$USER/projects/AUR/*/*.tar.bz2" \
        --exclude "sh:/home/$USER/projects/AUR/*/*.pkg.tar" \
        --exclude "sh:/home/$USER/projects/AUR/*/*/*" \
        --exclude "sh:/home/$USER/projects/Courses/**/*.pdf" \
        --exclude "sh:/home/$USER/projects/Courses/**/*.npz" \
        --exclude "/home/$USER/projects/blog/public" \
        --exclude "sh:/home/$USER/**/__pycache__" \
        "${REPO}::{now:%Y-%m-%d_%H:%M:%S}" \
        ~/.config \
        ~/.local/share/gnupg \
        ~/.local/share/keyrings \
        ~/.ssh \
        ~/scripts \
        ~/Pictures \
        ~/projects \
        ~/Documents \
        ~/.bashrc \
        ~/.bash_profile \
        ~/.xinitrc \
        ~/.vimrc \
        ~/.gitignore \
        /etc/pacman.d/hooks \
        /etc/pacman.d/mirrorlist \
        /etc/pacman.conf \
        /etc/mkinitcpio.d \
        /etc/mkinitcpio.conf \
        /etc/tlp.d \
        /etc/tlp.conf \
        /etc/sysctl.d \
        /etc/modprobe.d \
        /etc/modules-load.d \
        /etc/udev/rules.d \
        /etc/systemd \
        /etc/smartdns \
        /etc/default/earlyoom \
        /etc/makepkg.conf \
        /boot/loader/loader.conf \
        /boot/loader/entries

    # warn for abnormal delta size
    last_backup_info=$(borg info "$REPO" --last 1 | grep "This archive:")
    last_size=$(echo "$last_backup_info" | awk '{print $7}')
    last_unit=$(echo "$last_backup_info" | awk '{print $8}')

    # anything other than "kB", including "MB", "GB", or possibly "B" (I dont't know the complete list of uints in borg backup)
    if [[ $last_unit != "kB" ]]; then
        # delta smaller than 2 MB is fine
        if ! [[ $last_unit == "MB" && $(echo "$last_size<2" | bc -l) -eq 1 ]]; then
            echo "Abnormal last backup size: $last_size $last_unit"
            notify-send -u critical "Abnormal last backup size: $last_size $last_unit"
            exit 2
        fi
    fi
}

function f_prune {
    borg prune -v --list --keep-within=10d --keep-daily=30 --keep-weekly=4 --keep-monthly=4 --save-space "$REPO"
}

function f_sync {
    for remote in ${RCLONE_REMOTE[@]}; do
        echo -e "\nuploading to ${remote} ..."
        rclone --stats-one-line -P --stats 1s --drive-use-trash=false sync "$REPO" ${remote}:"$PREFIX"-borg -v --timeout=30s --fast-list --transfers=10
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

ask_user $O_BACKUP "Create a new archive?" f_backup
ask_user $O_PRUNE "Prune archives?" f_prune
ask_user $O_SYNC "Sync to cloud storage?" f_sync
