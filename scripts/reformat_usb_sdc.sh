devmon -r
sudo wipefs --all /dev/sdc
sudo cfdisk /dev/sdc
sudo pacman -S dosfstools
sudo mkfs.fat -F 32 -n HEF /dev/sdc1
sudo pacman -Rns dosfstools

