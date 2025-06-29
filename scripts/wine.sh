#!/bin/bash

set -eEuo pipefail
failure() {
    echo "line: $1 command: $2"
    exit "$3"
}
trap 'failure ${LINENO} "$BASH_COMMAND" $?' ERR

setup() {
    # should be fine if it is already enabled
    sudo sed -i 's/^#\[multilib\]$/\[multilib\]/' /etc/pacman.conf
    sudo sed -i '/^\[multilib\]$/{n; s/^#Include = \/etc\/pacman.d\/mirrorlist$/Include = \/etc\/pacman.d\/mirrorlist/}' /etc/pacman.conf

    # update first to fetch multilib database
    sudo pacman -Syu

    yay -S --needed wine-staging wine-gecko wine-mono winetricks dxvk-bin lib32-mesa expac
    sudo pacman -S --asdeps --needed "$(expac -S '%o' wine-staging)"

    # initialize wine prefix
    mkdir -p "$WINEPREFIX"
    wineboot -u

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

