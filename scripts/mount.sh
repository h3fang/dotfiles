#!/bin/sh

mkdir -p /run/media/enigma/Windows
ntfs-3g /dev/sda3 /run/media/enigma/Windows

mkdir -p /run/media/enigma/Apps
ntfs-3g /dev/sdb1 /run/media/enigma/Apps

mkdir -p /run/media/enigma/Data
ntfs-3g /dev/sdb3 /run/media/enigma/Data

mkdir -p /run/media/enigma/Stash
ntfs-3g /dev/sdb5 /run/media/enigma/Stash

