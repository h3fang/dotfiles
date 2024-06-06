#!/bin/bash

MINICONDA_PATH=~/.local/share/miniconda3
INSTALLER_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"

if [[ -d "$MINICONDA_PATH" ]]; then
    read -p "found existing ~/.local/miniconda3, remove it? y/[n]" -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$MINICONDA_PATH"
    fi
fi

read -p "install the latest miniconda? (y/[n]) " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # silent install to $MINICONDA_PATH
    MINICONDA_FILE=$(mktemp)
    curl -Lo "$MINICONDA_FILE" "$INSTALLER_URL"
    bash "$MINICONDA_FILE" -b -p "$MINICONDA_PATH"
    rm "$MINICONDA_FILE"
fi

# shellcheck source=/dev/null
source "${MINICONDA_PATH}/bin/activate"

conda config --system --set changeps1 false

# update base
conda update conda

