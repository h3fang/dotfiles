#!/bin/sh

BACKUP_LOC=/run/media/enigma/stash/backup/

# no slash after source directory
rsync -ahv --delete --ignore-errors --delete-excluded \
    --exclude="MATLAB" \
    --exclude="arch-${USER}-*.tar.zst" \
    --exclude="projects/build" \
    --exclude="projects/*/[dD]ata" \
    --exclude="projects/*/[rR]esults/**/*.npz" \
    --exclude="projects/AUR/*/*/*" \
    --exclude="projects/AUR/*/*.tar.?z" \
    --exclude="projects/AUR/*/*.tar.bz2" \
    --exclude="projects/AUR/*/*.tar.zst" \
    --exclude=".cache" \
    --exclude=".nv" \
    --exclude=".gvfs" \
    --exclude=".theano" \
    --exclude=".thumbnails" \
    --exclude=".wine" \
    --exclude=".local/miniconda3" \
    --exclude=".local/share/Trash" \
    --exclude=".local/share/Steam" \
    --exclude=".local/share/gvfs-metadata" \
    --exclude=".local/share/recently-used.xbel*" \
    --exclude=".config/chromium" \
    --exclude=".config/Code/*Cache*" \
    --exclude=".config/Code - OSS/*Cache*" \
    --exclude=".config/VSCodium/*Cache*" \
    --exclude=".config/Code/logs" \
    --exclude=".config/Code - OSS/logs" \
    --exclude=".config/VSCodium/logs" \
    --exclude=".vscode/extensions" \
    --exclude=".vscode-oss/extensions" \
    ~ "$BACKUP_LOC"

for target in /etc /boot/loader /mnt/win_data; do
    if [[ -d "$target" ]]; then
        rsync -ahv --delete --ignore-errors --delete-excluded "$target" "$BACKUP_LOC"
    fi
done

