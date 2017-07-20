#!/bin/sh

hda-verb /dev/snd/hwC0D0 0x20 SET_COEF_INDEX 0x67
hda-verb /dev/snd/hwC0D0 0x20 SET_PROC_COEF 0x3000

modprobe acpi_call
echo "\_SB.PCI0.PEG0.PEGP._OFF" > /proc/acpi/call
rmmod acpi_call

#sleep 30
#mkdir -p /run/media/enigma/Stash
#ntfs-3g /dev/sdb5 /run/media/enigma/Stash
