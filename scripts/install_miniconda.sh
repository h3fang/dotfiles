#!/bin/bash

MINICONDA_PATH=~/.local/miniconda3
INSTALLER_URL="https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh"

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
    read -p "use installer from tsinghua mirror? (y/[n]) " -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALLER_URL="https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    fi

    # silent install to $MINICONDA_PATH
    MINICONDA_FILE=$(mktemp)
    curl -Lo "$MINICONDA_FILE" "$INSTALLER_URL"
    bash "$MINICONDA_FILE" -b -p "$MINICONDA_PATH"
    rm "$MINICONDA_FILE"
fi

# shellcheck source=/dev/null
source "${MINICONDA_PATH}/bin/activate"

conda config --system --set changeps1 false

read -p "use tsinghua anaconda mirror? (y/[n]) " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    conda config --system --set show_channel_urls yes
    conda config --system --add channels defaults
    conda config --system --add default_channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
    conda config --system --set custom_channels.pytorch https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    conda config --system --set custom_channels.conda-forge https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
fi

# update base
conda update conda

# create environments
for f in ~/.config/conda/*.yml; do
    e=$(basename -s .yml "$f")
    read -p "remove (if exists) and create environment $e ? (y/[n]) " -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        conda remove -n "$e" --all
        conda env create -f "$f"

        # use conda gcc_linux-64 instead of system gcc to avoid the mismatch of binutils between gcc tools
        # https://wiki.gentoo.org/wiki/Binutils_2.32_upgrade_notes/elfutils_0.175:_unable_to_initialize_decompress_status_for_section_.debug_info

        # conda install -n "$e" gcc_linux-64
    fi
done
