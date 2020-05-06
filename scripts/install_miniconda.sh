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
conda config --system --set show_channel_urls true

if [[ -n $USE_MIRROR ]]; then
    conda config --system --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
    # It's important to make pytoch on the top of the list, otherwise the pytorch package from main will be installed.
    conda config --system --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch
else
    conda config --system --remove channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
    conda config --system --remove channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch
fi

# update base
conda update conda

N_GPUS=$(lspci | grep -i nvidia | grep -i 3d | wc -l)

read -p "setup main? (y/[n]) " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    conda remove -n main --all

    # create "main" environment with popular packages
    # use conda gcc_linux-64 instead of system gcc to avoid the mismatch of binutils between gcc tools
    # https://wiki.gentoo.org/wiki/Binutils_2.32_upgrade_notes/elfutils_0.175:_unable_to_initialize_decompress_status_for_section_.debug_info
    conda create -n main numpy scipy pandas matplotlib seaborn scikit-learn tqdm pillow h5py xlrd shapely gcc_linux-64 cython
    source ~/.local/miniconda3/bin/activate main

    # pytorch
    if [ $N_GPUS -gt 0 ]; then
        conda install -n main pytorch cudatoolkit=10.2
    else
        conda install -n main pytorch cpuonly
    fi

    # gym, vispy
    pip install gym vispy

    conda deactivate
fi
