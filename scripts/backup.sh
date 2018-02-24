#!/bin/sh

tar --exclude='/home/enigma/.config/Atom' --exclude='/home/enigma/.config/chromium' --exclude='/home/enigma/projects/ns3/src/ns-allinone-3.27/ns-3.27/src' --exclude='/home/enigma/projects/ns3/src/ns-allinone-3.27/ns-3.27/build' --exclude='/home/enigma/projects/ns3/src/ns-allinone-3.27/ns-3.27/src' --exclude='/home/enigma/projects/ns3/ns*' --exclude='/home/enigma/projects/ns3/pkg' --exclude='/home/enigma/projects/ns3/src/ns3*' -zcvf arch-enigma-home-$(date -I).tar.gz ~/.config ~/projects ~/scripts

