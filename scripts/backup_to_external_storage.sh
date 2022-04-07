#!/bin/bash

set -euo pipefail

DEV=$1
BACKUP_DIR=/mnt/vault/backup

sudo cryptsetup open "$DEV" vault

if [[ ! -d /mnt/vault ]]; then
    sudo mkdir /mnt/vault
    sudo chown "$USER":"$USER" /mnt/vault
fi

sudo mount /dev/mapper/vault /mnt/vault

if [[ ! -d /mnt/vault/backup ]]; then
    mkdir "$BACKUP_DIR"
fi

rsync -ahv --delete --delete-excluded \
    --exclude="projects/AUR/*/*/*" \
    --exclude="projects/AUR/*/*.tar.?z" \
    --exclude="projects/AUR/*/*.tar.bz2" \
    --exclude="projects/AUR/*/*.tar.zst" \
    --exclude="projects/**/target/" \
    --exclude=".cache" \
    --exclude=".local/miniconda3" \
    --exclude=".local/share/Trash" \
    --exclude=".local/share/Steam" \
    --exclude=".local/share/wine" \
    --exclude=".local/share/wine_home" \
    --exclude=".local/share/cargo" \
    --exclude=".local/share/rustup" \
    --exclude=".local/share/godot" \
    --exclude=".local/share/gvfs-metadata" \
    --exclude=".local/share/recently-used.xbel*" \
    --exclude=".config/chromium" \
    --exclude=".config/Code/*Cache*" \
    --exclude=".config/Code/User/workspaceStorage" \
    --exclude=".config/Code/User/globalStorage" \
    --exclude=".config/Code/logs" \
    --exclude=".config/draw.io" \
    --exclude=".vscode" \
    --exclude="Videos" \
    --exclude="VMs" \
    ~ "$BACKUP_DIR"

for target in /etc /boot/loader /var/lib/iwd /var/log/pacman.log ; do
    if [[ -d "$target" ]]; then
        rsync -ahv --delete --ignore-errors --delete-excluded "$target" "$BACKUP_DIR"
    fi
done

sudo umount /mnt/vault
sudo cryptsetup close vault
udisksctl power-off -b "$DEV"

