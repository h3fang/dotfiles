#!/bin/sh

use_nvidia()
{
    cp /etc/X11/xorg.conf.nvidia /etc/X11/xorg.conf

    # comment out poweroff nvidia card cmds
    HWFIXPath="/home/enigma/hwfix.sh"
    sed -i '/^modprobe acpi_call/ s/^/#/' $HWFIXPath
    sed -i '/^echo "\\_SB.PCI0.PEG0.PEGP._OFF" > \/proc\/acpi\/call/ s/^/#/' $HWFIXPath
    sed -i '/^rmmod acpi_call/ s/^/#/' $HWFIXPath
    
    # remove blacklist nvidia card conf
    mv /usr/lib/modprobe.d/graphicscard.conf /usr/lib/modprobe.d/graphicscard.conf.backup

    # enable PRIME
    sed -i '/^#xrandr --setprovideroutputsource modesetting NVIDIA-0/ s/^#//' /etc/lightdm/display_setup.sh
}

use_intel()
{
    cp /etc/X11/xorg.conf.intel /etc/X11/xorg.conf

    # poweroff nvidia card
    HWFIXPath="/home/enigma/hwfix.sh"
    sed -i '/^#modprobe acpi_call/ s/^#//' $HWFIXPath
    sed -i '/^#echo "\\_SB.PCI0.PEG0.PEGP._OFF" > \/proc\/acpi\/call/ s/^#//' $HWFIXPath
    sed -i '/^#rmmod acpi_call/ s/^#//' $HWFIXPath

    # blacklist nvidia card
    mv /usr/lib/modprobe.d/graphicscard.conf.backup /usr/lib/modprobe.d/graphicscard.conf

    # disable PRIME
    sed -i '/^xrandr --setprovideroutputsource modesetting NVIDIA-0/ s/^/#/' /etc/lightdm/display_setup.sh
}

