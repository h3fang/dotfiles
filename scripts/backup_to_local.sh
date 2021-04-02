#!/bin/sh

BACKUP_LOC=/run/media/$USER/stash/backup/

rsync -ahv --delete --delete-excluded \
    --exclude="projects/AUR/*/*/*" \
    --exclude="projects/AUR/*/*.tar.?z" \
    --exclude="projects/AUR/*/*.tar.bz2" \
    --exclude="projects/AUR/*/*.tar.zst" \
    --exclude=".cache" \
    --exclude=".local/miniconda3" \
    --exclude=".local/share/Trash" \
    --exclude=".local/share/Steam" \
    --exclude=".local/share/wine_home" \
    --exclude=".local/share/cargo" \
    --exclude=".local/share/gvfs-metadata" \
    --exclude=".local/share/recently-used.xbel*" \
    --exclude=".config/chromium" \
    --exclude=".config/Code/*Cache*" \
    --exclude=".config/Code/User/workspaceStorage" \
    --exclude=".config/Code/User/globalStorage" \
    --exclude=".config/Code/logs" \
    --exclude=".vscode" \
    ~ "$BACKUP_LOC"

for target in /etc /boot/loader /var/lib/iwd /var/log/pacman.log ; do
    if [[ -d "$target" ]]; then
        rsync -ahv --delete --ignore-errors --delete-excluded "$target" "$BACKUP_LOC"
    fi
done

