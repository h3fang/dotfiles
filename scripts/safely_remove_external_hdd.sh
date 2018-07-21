#!/bin/sh

if [ "$#" -eq 1 ] ; then
    sync && devmon -r && sudo hdparm -Y /dev/$1
else
    echo "Error: need one argument for target device"
fi

