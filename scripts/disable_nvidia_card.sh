#!/bin/sh

modprobe acpi_call
echo "\_SB.PCI0.PEG0.PEGP._OFF" > /proc/acpi/call
rmmod acpi_call

