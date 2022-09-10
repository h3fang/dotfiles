#!/bin/bash

set -eu

DDIR=${1:-$HOME/Downloads}

if [[ ! -d "$DDIR" ]]; then
    mkdir -p "$DDIR"
fi

cd "$DDIR"

echo "Downloading latest arch iso to $DDIR ..."

curl -LO https://mirrors.sjtug.sjtu.edu.cn/archlinux/iso/latest/archlinux-x86_64.iso
curl -LO https://mirrors.sjtug.sjtu.edu.cn/archlinux/iso/latest/archlinux-x86_64.iso.sig

pacman-key -v archlinux-x86_64.iso.sig

