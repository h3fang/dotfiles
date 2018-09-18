#!/bin/sh

# no space after comma
# no slash after source directory
rsync -ahv --delete --ignore-errors --delete-excluded --exclude={"MATLAB",".cache","projects/*/Data","projects/AUR/*/*/*","projects/AUR/*/*.tar.?z",".local/share/Trash",".nv",".thumbnails",".gvfs",".config/Code - OSS/*Cache*",".config/chromium",".config/Code - OSS/logs",".local/share/gvfs-metadata",".local/share/recently-used.xbel*","arch-enigma-home-*.tar.gz",".vscode-oss/extensions"} ~ /media/stash/backup/
#rsync -ahv --delete --ignore-errors --delete-excluded /etc /media/stash/backup/
#rsync -ahv --delete --ignore-errors --delete-excluded /boot/loader /media/stash/backup/
#rsync -ahv --delete --ignore-errors --delete-excluded /usr/lib/modprobe.d /media/stash/backup/
#rsync -ahv --delete --ignore-errors --delete-excluded /usr/lib/modules-load.d /media/stash/backup/

for target in /etc /boot/loader /usr/lib/modprobe.d /usr/lib/modules-load.d ; do
    rsync -ahv --delete --ignore-errors --delete-excluded $target /media/stash/backup/
done

