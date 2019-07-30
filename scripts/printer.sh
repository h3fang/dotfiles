#!/bin/sh

# hplip is for HP printers, see https://wiki.archlinux.org/index.php/CUPS/Printer-specific_problems
sudo pacman -S cups hplip
sudo systemctl enable --now org.cups.cupsd.service

# open http://localhost:631/ in web browser
# 1) add current user to groups with printer administration privileges defined in SystemGroup in the /etc/cups/cups-files.conf or 2) login as root
# add printer
# print

