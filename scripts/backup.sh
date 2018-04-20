#!/bin/sh

tar --exclude='/home/enigma/.config/mpv/watch_later' \
    --exclude='/home/enigma/.config/Atom' \
    --exclude='/home/enigma/.config/chromium' \
    --exclude='/home/enigma/.config/Code' \
    --exclude='/home/enigma/projects/ns3/src' \
    --exclude='/home/enigma/projects/ns3/ns*' \
    --exclude='/home/enigma/projects/ns3/pkg' \
    --exclude='/home/enigma/projects/ClusterAD/Data' \
    -zcvf arch-enigma-home-$(date -I).tar.gz \
    ~/.config \
    ~/projects \
    ~/scripts \
    ~/.gtkrc-2.0 \
    ~/.gitconfig \
    ~/.bashrc \
    ~/.vimrc \
    ~/.gitignore
