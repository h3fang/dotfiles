#!/bin/sh

REPO=~/backups
PREFIX=arch-enigma-home

borg create --compression auto,zstd,10 --stats --list --filter=AME \
    --exclude='/home/enigma/.config/mpv/watch_later' \
    --exclude='/home/enigma/.config/Atom' \
    --exclude='/home/enigma/.config/borg/security' \
    --exclude='/home/enigma/.config/Code' \
    --exclude='/home/enigma/.config/Code - OSS' \
    --exclude='/home/enigma/.config/chromium' \
    --exclude='/home/enigma/.config/libreoffice' \
    --exclude='/home/enigma/.config/GIMP' \
    --exclude='/home/enigma/.config/pulse' \
    --exclude='/home/enigma/.config/QtProject/qtcreator/qbs' \
    --exclude='/home/enigma/.config/QtProject/qtcreator/.helpcollection' \
    --exclude='/home/enigma/.config/fcitx5/conf/cached_layouts' \
    --exclude='/home/enigma/.config/ibus/bus' \
    --exclude='sh:/home/enigma/.ssh/known_hosts' \
    --exclude='sh:/home/enigma/projects/**/[bB]uild' \
    --exclude='sh:/home/enigma/projects/**/[dD]ata' \
    --exclude='sh:/home/enigma/projects/**/[rR]esults' \
    --exclude='sh:/home/enigma/projects/**/.vscode/ipch' \
    --exclude="sh:/home/enigma/projects/AUR/*/*.tar.?z" \
    --exclude="sh:/home/enigma/projects/AUR/*/*.tar.bz2" \
    --exclude='sh:/home/enigma/projects/AUR/*/*/*' \
    --exclude='sh:/home/enigma/projects/Courses/**/*.pdf' \
    --exclude='sh:/home/enigma/projects/Courses/**/*.npz' \
    --exclude='sh:/home/enigma/**/__pycache__' \
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

# pruning
borg prune -v --list --keep-within=10d --keep-daily=30 --keep-weekly=4 --keep-monthly=3 $REPO

echo
read -p "Sync with Google Drive (y/[n])? " -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo -e "\nuploading ..."
    rclone --stats-one-line -P --stats 1s --drive-use-trash=false sync $REPO gdrv:${PREFIX}-borg -v --timeout=30s
fi

echo -e "\nDone."
