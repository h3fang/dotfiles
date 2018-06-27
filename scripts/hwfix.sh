#!/bin/sh

#hda-verb /dev/snd/hwC0D0 0x20 SET_COEF_INDEX 0x67
#hda-verb /dev/snd/hwC0D0 0x20 SET_PROC_COEF 0x3000

mount --bind /mnt/cache/.cache /home/enigma/.cache
mount --bind /mnt/cache/.config /home/enigma/.config

modprobe acpi_call
echo "\_SB.PCI0.PEG0.PEGP._OFF" > /proc/acpi/call
rmmod acpi_call

