#!/bin/sh

IMG=/tmp/swaylock-blur.png
grim $IMG
convert $IMG -blur 0x6 $IMG
composite -gravity center ~/Pictures/lock.png $IMG $IMG
swaylock -fel --indicator-radius 150 -i $IMG
rm $IMG
