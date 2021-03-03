#!/bin/bash
# requires trash-cli

# remove garbage files
# clean browser profiles

trash-put \
    ~/.local/share/recently-used.xbel* \
    ~/.local/share/gegl-*/ \
    ~/.cache/thumbnails \
    ~/.cache/chromium \
    ~/.config/mpv/watch_later \
    ~/.config/Code/User/workspaceStorage/ \
    ~/.config/Code/User/*Cache/ \
    ~/.cache/babl/ \
    ~/.cache/bazel/ \
    ~/.cache/g-ir-scanner/ \
    ~/.cache/gstreamer-*/ \
    ~/.cache/jedi/ \
    ~/.cache/pip/

~/scripts/browser-vacuum.sh
~/scripts/clean_bash_history.sh

