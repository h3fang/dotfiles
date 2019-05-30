#!/bin/sh

BACKUP_LOC=/run/media/enigma/stash/backup/

# no slash after source directory
rsync -ahv --delete --ignore-errors --delete-excluded \
    --exclude="MATLAB" \
    --exclude="arch-enigma-home-*.tar.gz" \
    --exclude="projects/build" \
    --exclude="projects/*/Data" \
    --exclude="projects/*/Results/**/*.npz" \
    --exclude="projects/AUR/*/*/*" \
    --exclude="projects/AUR/*/*.tar.?z" \
    --exclude=".cache" \
    --exclude=".nv" \
    --exclude=".gvfs" \
    --exclude=".theano" \
    --exclude=".thumbnails" \
    --exclude=".local/miniconda3" \
    --exclude=".local/share/Trash" \
    --exclude=".local/share/Steam" \
    --exclude=".local/share/gvfs-metadata" \
    --exclude=".local/share/recently-used.xbel*" \
    --exclude=".config/chromium" \
    --exclude=".config/Code/*Cache*" \
    --exclude=".config/Code - OSS/*Cache*" \
    --exclude=".config/Code/logs" \
    --exclude=".config/Code - OSS/logs" \
    --exclude=".vscode/extensions" \
    --exclude=".vscode-oss/extensions" \
    ~ $BACKUP_LOC

for target in /etc /boot/loader /usr/lib/modprobe.d /usr/lib/modules-load.d ; do
    rsync -ahv --delete --ignore-errors --delete-excluded $target $BACKUP_LOC
done

