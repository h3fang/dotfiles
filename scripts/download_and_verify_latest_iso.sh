#!/bin/sh

cd /tmp

VER=$(date +%Y.%m.01)

curl -O https://mirrors.sjtug.sjtu.edu.cn/archlinux/iso/$VER/archlinux-$VER-x86_64.iso
curl -O https://mirrors.sjtug.sjtu.edu.cn/archlinux/iso/$VER/archlinux-$VER-x86_64.iso.sig

#gpg --keyserver pgp.mit.edu --keyserver-options auto-key-retrieve --verify archlinux-$VER-x86_64.iso.sig
pacman-key -v archlinux-$VER-x86_64.iso.sig
