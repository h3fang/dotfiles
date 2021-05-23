#!/bin/bash

set -eu

DDIR=${1:-$HOME/Downloads}

if [[ ! -d "$DDIR" ]]; then
    mkdir -p "$DDIR"
fi

cd "$DDIR"

VER=$(date +%Y.%m.01)

echo "Downloading latest arch iso to $DDIR ..."

curl -LO https://mirrors.sjtug.sjtu.edu.cn/archlinux/iso/"$VER"/archlinux-"$VER"-x86_64.iso
curl -LO https://mirrors.sjtug.sjtu.edu.cn/archlinux/iso/"$VER"/archlinux-"$VER"-x86_64.iso.sig

pacman-key -v archlinux-"$VER"-x86_64.iso.sig

