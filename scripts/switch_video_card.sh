#!/bin/sh

function use_nvidia
{
    sudo cp /etc/X11/xorg.conf.nvidia /etc/X11/xorg.conf

    outputclass="/usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf"
    if [ -e $outputclass.backup ]
    then
        sudo mv $outputclass.backup $outputclass
    fi

    # do not poweroff nvidia GPU
    HWFIXPath="/home/enigma/scripts/hwfix.sh"
    sudo sed -i '/^modprobe acpi_call/ s/^/#/' $HWFIXPath
    sudo sed -i '/^echo "\\_SB.PCI0.PEG0.PEGP._OFF" > \/proc\/acpi\/call/ s/^/#/' $HWFIXPath
    sudo sed -i '/^rmmod acpi_call/ s/^/#/' $HWFIXPath

    # remove blacklist nvidia card conf
    sudo mv /usr/lib/modprobe.d/graphicscard.conf /usr/lib/modprobe.d/graphicscard.conf.backup

    # comment out all PRIME settings
    sudo sed -i '/^xrandr --set/ s/^/#/' /etc/lightdm/display_setup.sh
    # enable reverse PRIME for nvidia
    sudo sed -i '/^#xrandr --setprovideroutputsource modesetting NVIDIA-0/ s/^#//' /etc/lightdm/display_setup.sh
}

function use_intel
{
    sudo cp /etc/X11/xorg.conf.intel /etc/X11/xorg.conf

    outputclass="/usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf"
    if [ -e $outputclass ]
    then
        sudo mv $outputclass $outputclass.backup
    fi

    # poweroff nvidia GPU
    HWFIXPath="/home/enigma/scripts/hwfix.sh"
    sudo sed -i '/^#modprobe acpi_call/ s/^#//' $HWFIXPath
    sudo sed -i '/^#echo "\\_SB.PCI0.PEG0.PEGP._OFF" > \/proc\/acpi\/call/ s/^#//' $HWFIXPath
    sudo sed -i '/^#rmmod acpi_call/ s/^#//' $HWFIXPath

    # blacklist nvidia
    sudo mv /usr/lib/modprobe.d/graphicscard.conf.backup /usr/lib/modprobe.d/graphicscard.conf

    # disable PRIME
    sudo sed -i '/^xrandr --set/ s/^/#/' /etc/lightdm/display_setup.sh
}

# to get PRIME work with nouveau, xf86-video-nouveau must be installed
function use_nouveau
{
    sudo cp /etc/X11/xorg.conf.nouveau /etc/X11/xorg.conf

    outputclass="/usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf"
    if [ -e $outputclass ]
    then
        sudo mv $outputclass $outputclass.backup
    fi

    # do not poweroff nvidia GPU
    HWFIXPath="/home/enigma/scripts/hwfix.sh"
    sudo sed -i '/^modprobe acpi_call/ s/^/#/' $HWFIXPath
    sudo sed -i '/^echo "\\_SB.PCI0.PEG0.PEGP._OFF" > \/proc\/acpi\/call/ s/^/#/' $HWFIXPath
    sudo sed -i '/^rmmod acpi_call/ s/^/#/' $HWFIXPath

    # blacklist nvidia
    sudo mv /usr/lib/modprobe.d/graphicscard.conf.backup /usr/lib/modprobe.d/graphicscard.conf
    # un-blacklist nouveau
    sudo mv /usr/lib/modprobe.d/nvidia.conf /usr/lib/modprobe.d/nvidia.conf.backup

    # comment out all PRIME settings
    sudo sed -i '/^xrandr --set/ s/^/#/' /etc/lightdm/display_setup.sh
    # enable reverse PRIME for nouveau
    sudo sed -i '/^#xrandr --setprovideroutputsource modesetting nouveau/ s/^#//' /etc/lightdm/display_setup.sh
}

