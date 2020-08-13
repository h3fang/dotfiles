#!/bin/sh

sudo pacman -S cups hplip
sudo systemctl enable --now org.cups.cupsd.service

echo 'hplip is for HP printers, see https://wiki.archlinux.org/index.php/CUPS/Printer-specific_problems'

echo
echo 'setup printers'
echo 'open http://localhost:631/ in web browser'
echo '1) add current user to groups with printer administration privileges defined in SystemGroup in the /etc/cups/cups-files.conf or 2) login as root'
echo 'add printer'
echo 'print'

