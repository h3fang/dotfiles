# no space after comma
# no slash after source directory
rsync -ahv --delete --ignore-errors --delete-excluded --exclude={"MATLAB",".cache","projects/*/Data",".local/share/Trash",".nv",".thumbnails",".gvfs",".config/Code/*Cache*",".config/chromium",".config/Code/logs",".local/share/gvfs-metadata",".local/share/recently-used.xbel*","arch-enigma-home-*.tar.gz",".vscode/extensions"} ~ /run/media/enigma/stash/backup/
rsync -ahv --delete --ignore-errors --delete-excluded /etc /run/media/enigma/stash/backup/
rsync -ahv --delete --ignore-errors --delete-excluded /boot/loader /run/media/enigma/stash/backup/
rsync -ahv --delete --ignore-errors --delete-excluded /usr/lib/modprobe.d /run/media/enigma/stash/backup/
rsync -ahv --delete --ignore-errors --delete-excluded /usr/lib/modules-load.d /run/media/enigma/stash/backup/

