#!/bin/bash

set -eEuo pipefail

# update system first
yay -Syu

# self-maintained packages
cd ~/projects/AUR
for pkg in $(pacman -Qgq modified) ; do
    cd "$pkg"
    makepkg -fsricC
    cd ..
done

