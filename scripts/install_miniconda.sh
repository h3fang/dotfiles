#!/bin/bash

read -p "remove then install latest miniconda? (y/[n]) " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # silent install to ~/.local/miniconda3
    MINICONDA_FILE=$(mktemp)
    rm -rf ~/.local/miniconda3
    curl -o $MINICONDA_FILE https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash $MINICONDA_FILE -b -p ~/.local/miniconda3
    rm $MINICONDA_FILE
fi

source ~/.local/miniconda3/bin/activate

conda config --system --set changeps1 false
conda config --system --set show_channel_urls true
conda config --system --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
# It's important to make pytoch on the top of the list, otherwise the pytorch package from main will be installed.
conda config --system --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch

# update base
conda update conda

N_GPUS=$(lspci | grep -i nvidia | grep -i 3d | wc -l)

read -p "setup main? (y/[n]) " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    conda remove -n main --all

    # create "main" environment with popular packages
    conda create -n main numpy scipy pandas matplotlib seaborn scikit-learn tqdm pillow h5py xlrd shapely
    source ~/.local/miniconda3/bin/activate main

    # pytorch
    if [ $N_GPUS -gt 0 ]; then
        conda install -n main pytorch cudatoolkit=10.1
    else
        conda install -n main pytorch cpuonly
    fi

    # gym
    conda install chardet future idna requests urllib3 cloudpickle
    pip install gym # will install pyglet, freetype-py, opencv-python and gym from pypi

    # vispy (the package in default channel is outdated)
    pip install vispy
    conda deactivate
fi

read -p "setup probability? (y/[n]) " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    conda remove -n probability --all

    # "probability" environment
    conda create --clone main -n probability
    source ~/.local/miniconda3/bin/activate probability
    if [ $N_GPUS -gt 0 ]; then
        pip install tensorflow-gpu tensorflow-probability
    else
        pip install tensorflow tensorflow-probability
    fi
    conda install -c conda-forge pymc3
    pip install pyro-ppl
    conda deactivate
fi
