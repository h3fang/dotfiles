#!/bin/bash

DOWNLOAD_URL="https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh"
USE_MIRROR=""

read -p "use tsinghua mirror? (y/[n]) " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    DOWNLOAD_URL="https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    USE_MIRROR="true"
fi

read -p "remove then install latest miniconda? (y/[n]) " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # silent install to ~/.local/miniconda3
    MINICONDA_FILE=$(mktemp)
    rm -rf ~/.local/miniconda3
    curl -o "$MINICONDA_FILE" "$DOWNLOAD_URL"
    bash $MINICONDA_FILE -b -p ~/.local/miniconda3
    rm $MINICONDA_FILE
fi

source ~/.local/miniconda3/bin/activate

conda config --system --set changeps1 false
conda config --system --add create_default_packages flake8
conda config --system --add create_default_packages black

# update base
conda update conda

# create environments
for f in ~/.config/conda/*.yml; do
    local e=$(basename -s .yml "$f")
    read -p "remove existing and setup $e ? (y/[n]) " -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        conda remove -n "$e" --all
        conda env create -f "$f"

        # use conda gcc_linux-64 instead of system gcc to avoid the mismatch of binutils between gcc tools
        # https://wiki.gentoo.org/wiki/Binutils_2.32_upgrade_notes/elfutils_0.175:_unable_to_initialize_decompress_status_for_section_.debug_info

        # source ~/.local/miniconda3/bin/activate "$e"
        # conda install -n "$e" gcc_linux-64
        # conda deactivate
    fi
done
