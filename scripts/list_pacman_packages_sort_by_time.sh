#!/bin/bash

for i in $(pacman -Qqe)
do
  grep "\[ALPM\] installed $i (" /var/log/pacman.log | tail -n 1
done | \
  sort -u | \
  sed -e 's/\[ALPM\] installed //' #-e 's/(.*$//'

