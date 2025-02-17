#!/bin/bash

set -euo pipefail

DEV=$1
MOUNT_DIR=/mnt/vault
BACKUP_DIR="${MOUNT_DIR}/backup"

sudo cryptsetup open "$DEV" vault

if [[ ! -d "$MOUNT_DIR" ]]; then
    sudo mkdir "$MOUNT_DIR"
    sudo chown "$USER":"$USER" "$MOUNT_DIR"
fi

sudo mount /dev/mapper/vault "$MOUNT_DIR"

if [[ ! -d "$BACKUP_DIR" ]]; then
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
    --exclude=".config/Code/*Cache*" \
    --exclude=".config/Code/User/workspaceStorage" \
    --exclude=".config/Code/User/globalStorage" \
    --exclude=".config/Code/logs" \
    --exclude=".vscode" \
    --exclude="Videos" \
    --exclude="VMs" \
    ~ "$BACKUP_DIR"

for target in /etc /boot/loader /var/lib/iwd /var/log/pacman.log ; do
    if [[ -d "$target" ]]; then
        sudo rsync -ahv --delete --ignore-errors --delete-excluded "$target" "$BACKUP_DIR"
    fi
done

sudo umount "$MOUNT_DIR"
sudo cryptsetup close vault
udisksctl power-off -b "$DEV"

