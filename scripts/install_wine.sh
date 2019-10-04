#!/bin/bash

set -eEuo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

sudo pacman -S --needed wine-staging wine_gecko wine-mono lib32-nvidia-utils lib32-libpulse lib32-libxml2 lib32-mpg123 lib32-lcms2 lib32-giflib lib32-libpng lib32-gnutls lib32-libldap lib32-libgpg-error lib32-gst-plugins-base lib32-gst-plugins-good winetricks

PKGEXT=.pkg.tar yay -S --needed dxvk-bin #dxvk-winelib-git

# use wine prefix in ~/.cache/wine instead of default ~/.wine, this is also exported in ~/scripts/envs
export WINEPREFIX=~/.cache/wine
# initialize wine prefix
wineboot -u
wait $(pgrep wineboot)
# dxvk
setup_dxvk install
# misc
winetricks vcrun2015 fontsmooth=rgb mimeassoc=off win7 isolate_home
