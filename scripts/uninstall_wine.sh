#!/bin/bash

set -e

yay -Rns $(pacman -Qq wine dxvk) wine-mono wine-gecko winetricks

# delete wine related files
rm -rf "$WINEPREFIX" \
    ~/.cache/winetricks \
    ~/.config/menus \
    ~/.local/share/applications \
    ~/.local/share/icons \
    ~/.local/share/mime \
    ~/.local/share/desktop-directories

