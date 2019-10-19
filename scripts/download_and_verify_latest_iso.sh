#!/bin/bash

DDIR=~/Downloads
if [[ -n $1 ]]; then
    DDIR="$1"
fi
mkdir -p $DDIR
cd $DDIR

VER=$(date +%Y.%m.01)

echo "Downloading latest arch iso to $DDIR ..."

curl -O https://mirrors.sjtug.sjtu.edu.cn/archlinux/iso/$VER/archlinux-$VER-x86_64.iso
curl -O https://mirrors.sjtug.sjtu.edu.cn/archlinux/iso/$VER/archlinux-$VER-x86_64.iso.sig

#gpg --keyserver pgp.mit.edu --keyserver-options auto-key-retrieve --verify archlinux-$VER-x86_64.iso.sig
pacman-key -v archlinux-$VER-x86_64.iso.sig
