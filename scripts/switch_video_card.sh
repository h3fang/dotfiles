#!/bin/sh

function use_nvidia
{
    sudo cp /etc/X11/xorg.conf.nvidia /etc/X11/xorg.conf

    # comment out poweroff nvidia card cmds
    HWFIXPath="/home/enigma/hwfix.sh"
    sudo sed -i '/^modprobe acpi_call/ s/^/#/' $HWFIXPath
    sudo sed -i '/^echo "\\_SB.PCI0.PEG0.PEGP._OFF" > \/proc\/acpi\/call/ s/^/#/' $HWFIXPath
    sudo sed -i '/^rmmod acpi_call/ s/^/#/' $HWFIXPath

    # remove blacklist nvidia card conf
    sudo mv /usr/lib/modprobe.d/graphicscard.conf /usr/lib/modprobe.d/graphicscard.conf.backup

    # enable PRIME
    sudo sed -i '/^#xrandr --setprovideroutputsource modesetting NVIDIA-0/ s/^#//' /etc/lightdm/display_setup.sh
}

function use_intel
{
    sudo cp /etc/X11/xorg.conf.intel /etc/X11/xorg.conf

    # poweroff nvidia card
    HWFIXPath="/home/enigma/hwfix.sh"
    sudo sed -i '/^#modprobe acpi_call/ s/^#//' $HWFIXPath
    sudo sed -i '/^#echo "\\_SB.PCI0.PEG0.PEGP._OFF" > \/proc\/acpi\/call/ s/^#//' $HWFIXPath
    sudo sed -i '/^#rmmod acpi_call/ s/^#//' $HWFIXPath

    # blacklist nvidia card
    sudo mv /usr/lib/modprobe.d/graphicscard.conf.backup /usr/lib/modprobe.d/graphicscard.conf

    # disable PRIME
    sudo sed -i '/^xrandr --setprovideroutputsource modesetting NVIDIA-0/ s/^/#/' /etc/lightdm/display_setup.sh
}

