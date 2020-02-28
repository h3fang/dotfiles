#!/bin/bash

set -e

source ~/.local/miniconda3/bin/activate

RED="\e[38;2;255;0;0m"
GREEN="\e[38;2;0;255;0m"
CLR="\e[0m"

for env in $(conda info -e | grep miniconda3 | awk '{print $1}'); do
  echo -en "${GREEN}updating environment ${RED}${env}${GREEN} ? (y/[n])${CLR}"
  read -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    conda activate "$env"
    # conda packages
    conda update --all
    # pip packages
    for pkg in $(conda list | grep pypi$ | awk '{print $1}'); do
      pip install --upgrade "$pkg"
    done
    conda deactivate
  fi
done

for env in $(conda info -e | grep miniconda3 | awk '{print $1}'); do
  echo -e "${GREEN}cleaning environment ${RED}${env}${GREEN} ...${CLR}"
  conda activate "$env"
  conda clean -ay
  conda deactivate
done

echo -e "${GREEN}updated all conda environments${CLR}"
