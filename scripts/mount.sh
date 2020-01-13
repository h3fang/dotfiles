#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
     echo "this script must be run with root privilege"
     exit 1
fi

mkdir -p /run/media/enigma/Apps
mount -t ntfs-3g -U 4CD6F67DD6F6669C /run/media/enigma/Apps

mkdir -p /run/media/enigma/Data
mount -t ntfs-3g -U F27402DA7402A189 /run/media/enigma/Data

mkdir -p /run/media/enigma/Stash
mount -t ntfs-3g -U DA8E17968E176A71 /run/media/enigma/Stash

