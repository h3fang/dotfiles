#!/bin/sh

# silent install to ~/.local/miniconda3
MINICONDA_FILE=/tmp/$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c $(shuf -i 20-50 -n 1))
rm -rf ~/.local/miniconda3
curl -o $MINICONDA_FILE https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash $MINICONDA_FILE -b -p ~/.local/miniconda3
rm $MINICONDA_FILE

# prevent conda activate from changing PS1
echo "changeps1: False" >> ~/.local/miniconda3/.condarc

# create "main" environment with popular packages
export PATH=~/.local/miniconda3/bin:$PATH
conda update conda
conda create -n main numpy scipy pandas matplotlib scikit-learn pillow h5py xlrd cython shapely
conda activate main
#conda install tensorflow-gpu keras
conda install pytorch cudatoolkit=10.0 -c pytorch
pip install --upgrade pymc3 vispy #tensorflow-probability
