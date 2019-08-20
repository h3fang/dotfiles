#!/bin/bash
# requires borg, notify-all, rclone (already setup)

REPO=/home/$USER/backups
PREFIX=arch-${HOSTNAME}-${USER}-home
RCLONE_REMOTE=gdrv

borg create --compression auto,zstd,10 --stats --list --filter=AME \
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
    --exclude "sh:/home/$USER/**/__pycache__" \
    ${REPO}::{now:%Y-%m-%d_%H:%M:%S} \
    ~/.config \
    ~/.ssh \
    ~/scripts \
    ~/Pictures \
    ~/projects \
    ~/Documents \
    ~/.gtkrc-2.0 \
    ~/.gitconfig \
    ~/.bashrc \
    ~/.bash_profile \
    ~/.xinitrc \
    ~/.vimrc \
    ~/.gitignore \
    ~/.latexmkrc

borg info $REPO

last_backup_info=$(borg info $REPO --last 1 | grep "This archive:")
last_size=$(echo $last_backup_info | awk '{print $7}')
last_unit=$(echo $last_backup_info | awk '{print $8}')

if [[ $(echo $last_size'>'10 | bc -l) == 1 && $last_unit != "kB" ]]; then
    echo "Abnormal last backup size: $last_size $last_unit"
    notify-all "Abnormal last backup size: $last_size $last_unit"
    exit 1
fi

# pruning
borg prune -v --list --keep-within=10d --keep-daily=30 --keep-weekly=4 --keep-monthly=4 $REPO

echo
read -p "Sync to cloud storage (y/[n])? " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "\nuploading ..."
    rclone --stats-one-line -P --stats 1s --drive-use-trash=false sync $REPO ${RCLONE_REMOTE}:${PREFIX}-borg -v --timeout=30s
fi

echo -e "\nDone."
