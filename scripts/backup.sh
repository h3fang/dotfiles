#!/bin/sh

tar -I pigz --exclude='.config/mpv/watch_later' \
    --exclude='.config/Atom' \
    --exclude='.config/chromium' \
    --exclude='.config/Code' \
    --exclude='projects/ns3/src' \
    --exclude='projects/ns3/ns*' \
    --exclude='projects/ns3/pkg' \
    --exclude='projects/ClusterAD/Data' \
    -cvf arch-enigma-home-$(date -I).tar.gz \
    ~/.config \
    ~/projects \
    ~/scripts \
    ~/.gtkrc-2.0 \
    ~/.gitconfig \
    ~/.bashrc \
    ~/.vimrc \
    ~/.gitignore

