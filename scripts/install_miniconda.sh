#!/bin/sh

# silent install to ~/.local/miniconda3
MINICONDA_FILE=/tmp/$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c $(shuf -i 20-50 -n 1))
rm -rf ~/.local/miniconda3
curl -o $MINICONDA_FILE https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash $MINICONDA_FILE -b -p ~/.local/miniconda3
rm $MINICONDA_FILE

# prevent conda activate from changing PS1
echo "changeps1: False" >> ~/.local/miniconda3/.condarc

# update base
source ~/.local/miniconda3/bin/activate
conda update conda

# create "main" environment with popular packages
conda create -n main numpy scipy pandas matplotlib scikit-learn pillow h5py xlrd shapely vispy
source ~/.local/miniconda3/bin/activate main
conda config --env --add channels pytorch
conda install -n main pytorch cudatoolkit=10.0

# "probability" environment
conda create --clone main -n probability
source ~/.local/miniconda3/bin/activate probability
pip install tensorflow-gpu==2.0.0-alpha0 tensorflow-probability
pip install pymc3
pip install pyro-ppl
