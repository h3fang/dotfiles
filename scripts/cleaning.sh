#!/bin/bash
# requires trash-cli, profile-cleaner

# remove garbage files
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

# remove useless entries in .bash_history
~/scripts/clean_bash_history.sh

# clean browser profiles
for browser in firefox chromium; do
    for pid in $(pidof "$browser"); do
        echo "waiting for $browser process $pid to close ..."
        tail --pid="$pid" -f /dev/null
    done
done

profile-cleaner f
profile-cleaner c

