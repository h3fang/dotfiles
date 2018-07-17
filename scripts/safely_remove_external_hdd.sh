#!/bin/sh

if [ "$#" -eq 1 ] ; then
    sync && devmon --unmount /dev/$1 && sudo hdparm -Y /dev/$1
else
    echo "Error: need one argument for target device"
fi

