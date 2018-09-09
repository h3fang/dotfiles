#!/bin/sh

curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh #(install to ~/.local/miniconda3)
rm Miniconda3-latest-Linux-x86_64.sh

# echo "alias miniconda='export PATH=~/.local/miniconda3/bin:$PATH'" >> ~/.bashrc
# open a new terminal, run miniconda

conda update conda
conda install numpy scipy pandas matplotlib sympy scikit-learn numba
conda update --all

