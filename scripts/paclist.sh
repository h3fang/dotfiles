#!/bin/bash

LOG_FILE=/tmp/pacman_install_log_$(date +%s)
cat /var/log/pacman.log | sed '/\[ALPM\] installed /s/\[ALPM\] installed //;t;d' > $LOG_FILE

for i in $(pacman -Qqe)
do
    grep "] $i (" $LOG_FILE | tail -n 1
done | sort

rm $LOG_FILE

