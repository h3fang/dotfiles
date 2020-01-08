#!/bin/bash

PREFIX=arch-${HOSTNAME}-${USER}-home
ARCHIVE=~/${PREFIX}-$(date -I).tar.zst

tar --exclude='.config/mpv/watch_later' \
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
    --exclude="projects/AUR/*/*.tar.?z" \
    --exclude="projects/AUR/*/*.tar.bz2" \
    --exclude="projects/AUR/*/*.pkg.tar" \
    --exclude='projects/AUR/*/*/*' \
    --exclude='projects/Courses/**/*.pdf' \
    --exclude='projects/Courses/**/*.npz' \
    --exclude='.~lock.*' \
    --exclude='**/__pycache__' \
    -cf - \
    ~/.config \
    ~/projects \
    ~/scripts \
    ~/Pictures \
    ~/.gtkrc-2.0 \
    ~/.gitconfig \
    ~/.bashrc \
    ~/.bash_profile \
    ~/.xinitrc \
    ~/.vimrc \
    ~/.gitignore \
    ~/.latexmkrc \
    | zstd -10 -T0 -o $ARCHIVE

echo
ls -hl ~/${PREFIX}*.tar.*

echo
read -p "Upload (y/[n])? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo -e "\nuploading ..."
    rclone --stats-one-line -P --stats 1s copy $ARCHIVE gdrv: -v --timeout=30s
fi

echo
read -p "Remove old backups (y/[n])? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    oldbackups=$(ls ~/$PREFIX*.tar.*)
    for f in ${oldbackups[@]}
    do
        if [[ "$f" != "$ARCHIVE" ]]
        then
            echo  "removing $f"
            rm $f
        fi
    done
fi

echo -e "\nDone."
