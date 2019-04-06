#!/bin/bash

source ~/.local/miniconda3/bin/activate
conda_envs=($(conda info -e | grep miniconda3 | awk '{print $1}'))
for i in "${conda_envs[@]}"
do
   :
  echo "updating environment $i ..."
  conda activate $i
  conda update --all --prune
done

conda clean -a

echo "updated all conda environments"

