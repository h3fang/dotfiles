#!/bin/bash

set -e

source ~/.local/miniconda3/bin/activate

RED="\e[38;2;255;0;0m"
GREEN="\e[38;2;0;255;0m"
CLR="\e[0m"

echo -e "${GREEN}updating environment ${RED}base${GREEN} ...${CLR}"
conda update --all

for f in ~/.config/conda/*.yml; do
  e=$(basename -s .yml "$f")
  echo -e "${GREEN}updating environment ${RED}${e}${GREEN} ...${CLR}"
  conda env update --prune --file "$f"
done

for e in $(conda info -e | grep miniconda3 | awk '{print $1}'); do
  echo -e "${GREEN}cleaning environment ${RED}${e}${GREEN} ...${CLR}"
  conda activate "$env"
  conda clean -pty
  conda deactivate
done

echo -e "${GREEN}updated all conda environments${CLR}"
