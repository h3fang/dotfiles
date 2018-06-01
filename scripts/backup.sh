#!/bin/sh

tar -I pigz --exclude='.config/mpv/watch_later' \
    --exclude='.config/Atom' \
    --exclude='.config/chromium' \
    --exclude='.config/Code' \
    --exclude='projects/ns3/src' \
    --exclude='projects/ns3/ns*' \
    --exclude='projects/ns3/pkg' \
    --exclude='projects/ClusterAD/Data' \
    --exclude='projects/Southwest-Weight-Estimation/Data' \
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
    ~/.vimrc \
    ~/.gitignore

