#!/bin/bash

sudo pacman -Rns steam

rm -rf ~/.local/share/{Steam,vulkan} \
    ~/.steam* \
    ~/.pulse-cookie

