#!/bin/bash

source ~/.local/miniconda3/bin/activate
for env in $(conda info -e | grep miniconda3 | awk '{print $1}'); do
  echo "updating environment $env ..."
  conda activate $env
  conda update --all
  for pkg in $(conda list | grep pypi$ | awk '{print $1}'); do
    # gym requires a specific version of pyglet
    if [[ $pkg != "pyglet" ]]; then
      pip install --upgrade $pkg
    fi
  done
  conda clean -a
done

echo "updated all conda environments"

