#!/bin/bash

set -eEuo pipefail
error_exit() {
    s=$?
    echo "$0: Error on line $LINENO"
    exit $s
}
trap error_exit ERR

setup() {
    # should be fine if it is already enabled
    sudo sed -i 's/^#\[multilib\]$/\[multilib\]/' /etc/pacman.conf
    sudo sed -i '/^\[multilib\]$/{n; s/^#Include = \/etc\/pacman.d\/mirrorlist$/Include = \/etc\/pacman.d\/mirrorlist/}' /etc/pacman.conf

    # update first to fetch multilib database
    sudo pacman -Syu

    yay -S --needed wine-staging wine-gecko wine-mono winetricks dxvk-bin lib32-mesa
    sudo pacman -S --asdeps --needed "$(pacman -Si wine-staging | sed -n '/^Opt/,/^Conf/p' | sed '$d' | sed 's/^Opt.*://g' | sed 's/^\s*//g' | tr '\n' ' ')"

    # initialize wine prefix
    wineboot -u
    if pgrep wineboot; then
        tail --pid="$(pgrep wineboot)" -f /dev/null
    fi
    if pgrep wineserver; then
        tail --pid="$(pgrep wineserver)" -f /dev/null
    fi
    sleep 3

    # dxvk
    setup_dxvk install --symlink
}

remove() {
    yay -Rns wine-staging wine-mono wine-gecko winetricks dxvk-bin
    yay -Rns "$(pacman -Qqttd | grep '^lib32-')" || true
    yay -Rns lib32-mesa || true

    # delete wine related files
    rm -rf "$WINEPREFIX:-~/.wine" \
        ~/.cache/winetricks \
        ~/.config/menus \
        ~/.local/share/icons \
        ~/.local/share/mime \
        ~/.local/share/desktop-directories

    echo 'Disable multilib in /etc/pacman.conf if necessary.'
}

if [[ $# -ne 1 ]]; then
    echo 'Usage: wine.sh install|uninstall'
elif [[ $1 == "install" ]]; then
    setup
elif [[ $1 == "uninstall" ]]; then
    remove
else
    echo 'Usage: wine.sh install|uninstall'
fi

