#!/bin/bash
# requires rclone

set -eEuo pipefail

PREFIX=arch-home-${USER}-$(cat /etc/machine-id | head -c 6)
ARCHIVE=~/${PREFIX}-$(date +"%F_%H-%M-%S").tar.zst

tar -I "zstd -T0 -19" --exclude='.config/mpv/watch_later' \
    --exclude='.config/Atom' \
    --exclude='.config/Code' \
    --exclude='.config/Code - OSS' \
    --exclude='.config/VSCodium' \
    --exclude='.config/chromium' \
    --exclude='.config/libreoffice' \
    --exclude='.config/GIMP' \
    --exclude='.config/pulse' \
    --exclude='.config/QtProject/qtcreator/qbs' \
    --exclude='.config/QtProject/qtcreator/.helpcollection' \
    --exclude='.config/fcitx/libpinyin/data' \
    --exclude='.config/menus' \
    --exclude='projects/build' \
    --exclude='projects/**/[bB]uild' \
    --exclude='projects/**/[dD]ata' \
    --exclude='projects/**/[rR]esults' \
    --exclude='projects/**/.vscode/ipch' \
    --exclude="projects/AUR/*/*.tar" \
    --exclude="projects/AUR/*/*.tar.gz" \
    --exclude="projects/AUR/*/*.tar.xz" \
    --exclude="projects/AUR/*/*.tar.bz2" \
    --exclude="projects/AUR/*/*.tar.zst" \
    --exclude="projects/AUR/*/*.zip" \
    --exclude="projects/AUR/*/*.AppImage" \
    --exclude="projects/AUR/*/pkg" \
    --exclude="projects/AUR/*/src" \
    --exclude='projects/AUR/*/*/*' \
    --exclude='projects/Courses/**/*.pdf' \
    --exclude='projects/Courses/**/*.npz' \
    --exclude='projects/blog/public' \
    --exclude='.~lock.*' \
    --exclude='**/__pycache__' \
    -cvf $ARCHIVE \
    .config \
    .local/share/gnupg \
    .local/share/keyrings \
    .ssh \
    projects \
    scripts \
    Pictures \
    .bashrc \
    .bash_profile \
    .xinitrc \
    .vimrc \
    .gitignore

ls -l "$ARCHIVE"

echo
read -p "Upload (y/[n])? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo -e "\nuploading ..."
    rclone --stats-one-line -P --stats 1s copy $ARCHIVE googledrive: -v --timeout=30s
fi

echo -e "\nDone."
