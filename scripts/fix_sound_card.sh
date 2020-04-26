#!/bin/sh

# need alsa-tools
hda-verb /dev/snd/hwC0D0 0x20 SET_COEF_INDEX 0x67 > /dev/null 2>&1
hda-verb /dev/snd/hwC0D0 0x20 SET_PROC_COEF 0x3000 > /dev/null 2>&1

