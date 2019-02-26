#!/bin/sh

# silent install to ~/.local/miniconda3
curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p ~/.local/miniconda3
rm Miniconda3-latest-Linux-x86_64.sh

# prevent conda activate from changing PS1
echo "changeps1: False" >> ~/.local/miniconda3/.condarc

# create "main" environment with popular packages
export PATH=~/.local/miniconda3/bin:$PATH
conda update conda
conda create -n main numpy scipy pandas matplotlib scikit-learn

