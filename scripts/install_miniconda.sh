#!/bin/sh

read -p "remove then install latest miniconda? (y/[n]) " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # silent install to ~/.local/miniconda3
    MINICONDA_FILE=/tmp/$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c $(shuf -i 20-50 -n 1))
    rm -rf ~/.local/miniconda3
    curl -o $MINICONDA_FILE https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash $MINICONDA_FILE -b -p ~/.local/miniconda3
    rm $MINICONDA_FILE
    # prevent conda activate from changing PS1
    echo "changeps1: False" >> ~/.local/miniconda3/.condarc
fi

# update base
source ~/.local/miniconda3/bin/activate
conda update conda

N_GPUS=$(lspci | grep -i nvidia | grep -i 3d | wc -l)

read -p "setup main? (y/[n]) " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    conda remove -n main --all

    # create "main" environment with popular packages
    conda create -n main numpy scipy pandas matplotlib scikit-learn pillow h5py xlrd shapely vispy
    source ~/.local/miniconda3/bin/activate main

    # pytorch
    conda config --env --add channels pytorch
    if [ $N_GPUS -gt 0 ]; then
        conda install -n main pytorch cudatoolkit=10.0
    else
        conda install -n main pytorch-cpu
    fi

    # gym
    conda install chardet future idna requests urllib3
    pip install gym # should only install pyglet and gym from pypi
fi

read -p "setup probability? (y/[n]) " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    conda remove -n probability --all

    # "probability" environment
    conda create --clone main -n probability
    source ~/.local/miniconda3/bin/activate probability
    if [ $N_GPUS -gt 0 ]; then
        pip install tensorflow-gpu==2.0.0-beta1 tensorflow-probability
    else
        pip install tensorflow==2.0.0-beta1 tensorflow-probability
    fi
    conda install -c conda-forge pymc3
    pip install pyro-ppl
fi

