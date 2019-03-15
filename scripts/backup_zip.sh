#!/bin/sh

ARCHIVE_NAME=~/arch-enigma-home-$(date -I).tar.gz

tar -I pigz \
    --exclude='.config/mpv/watch_later' \
    --exclude='.config/Atom' \
    --exclude='.config/Code' \
    --exclude='.config/Code - OSS' \
    --exclude='.config/chromium' \
    --exclude='.config/libreoffice' \
    --exclude='.config/GIMP' \
    --exclude='.config/pulse' \
    --exclude='.config/QtProject/qtcreator/qbs' \
    --exclude='.config/QtProject/qtcreator/.helpcollection' \
    --exclude='.config/fcitx/libpinyin/data' \
    --exclude='projects/**/build' \
    --exclude='projects/**/Data' \
    --exclude='projects/**/Results' \
    --exclude="projects/AUR/*/*.tar.?z" \
    --exclude="projects/AUR/*/*.tar.bz2" \
    --exclude='projects/AUR/*/*/*' \
    --exclude='projects/Courses/**/*.pdf' \
    --exclude='.~lock.*' \
    --exclude='**/__pycache__' \
    -cvf $ARCHIVE_NAME \
    ~/.config \
    ~/projects \
    ~/scripts \
    ~/Pictures \
    ~/Documents \
    ~/.gtkrc-2.0 \
    ~/.gitconfig \
    ~/.bashrc \
    ~/.bash_profile \
    ~/.xinitrc \
    ~/.vimrc \
    ~/.gitignore \
    ~/.latexmkrc

echo -e "\nuploading ..."
rclone copy $ARCHIVE_NAME gdrv: -v --timeout=30s

