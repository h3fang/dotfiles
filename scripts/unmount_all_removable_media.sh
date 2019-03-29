#!/bin/bash
# no extra dependency

sync

for device in /sys/block/*
do
    if udevadm info --query=property --path=$device | grep -q ^ID_BUS=usb; then
        echo found $device to unmount
        DEVTO=`echo $device|awk -F"/" 'NF>1{print $NF}'`
        echo `df -h|grep "$(ls /dev/$DEVTO*)"|awk '{print $1}'` is the exact device
        UM=`df -h|grep "$(ls /dev/$DEVTO*)"|awk '{print $1}'`
        if sudo umount $UM; then
            echo umounted $UM
        else
            echo failed to unmount $UM
        fi
    fi
done

