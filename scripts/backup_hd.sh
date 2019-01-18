#!/bin/sh

# no space after comma
# no slash after source directory
rsync -ahv --delete --ignore-errors --delete-excluded --exclude={"MATLAB",".cache","projects/*/Data","projects/*/Results","projects/AUR/*/*/*","projects/AUR/*/*.tar.?z"i,".local/miniconda3",".local/share/Trash",".local/share/Steam",".nv",".thumbnails",".gvfs",".config/Code/*Cache*",".config/Code - OSS/*Cache*",".config/chromium",".config/Code/logs",".config/Code - OSS/logs",".local/share/gvfs-metadata",".local/share/recently-used.xbel*","arch-enigma-home-*.tar.gz",".vscode/extensions",".vscode-oss/extensions"} ~ /media/stash/backup/

for target in /etc /boot/loader /usr/lib/modprobe.d /usr/lib/modules-load.d ; do
    rsync -ahv --delete --ignore-errors --delete-excluded $target /media/stash/backup/
done

