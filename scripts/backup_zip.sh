#!/bin/sh

tar -I pigz \
    --exclude='.config/mpv/watch_later' \
    --exclude='.config/Atom' \
    --exclude='.config/chromium' \
    --exclude='.config/Code - OSS' \
    --exclude='.config/QtProject/qtcreator/qbs' \
    --exclude='.config/QtProject/qtcreator/.helpcollection' \
    --exclude='projects/**/build' \
    --exclude='projects/**/Data' \
    --exclude='projects/**/Results' \
    --exclude="projects/AUR/*/*.tar.?z" \
    --exclude='projects/AUR/*/*/*' \
    --exclude='projects/Courses/**/*.pdf' \
    --exclude='.~lock.*' \
    -cvf arch-enigma-home-$(date -I).tar.gz \
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
    ~/.gitignore

