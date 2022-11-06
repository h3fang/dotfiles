#!/bin/bash

### Storage

# (manual) check partition alignment
# https://wiki.archlinux.org/index.php/Partitioning#Partition_alignment

# (manual) Disabling access time update
# https://wiki.archlinux.org/title/Ext4#Disabling_access_time_update
# https://wiki.archlinux.org/title/Fstab#atime_options
# /etc/fstab relatime noatime

# (manual) Increasing commit interval
# https://wiki.archlinux.org/title/Ext4#Increasing_commit_interval
# /etc/fstab commit=60

# (manual) Enabling fast_commit in existing ext4 filesystems
# https://wiki.archlinux.org/title/Ext4#Enabling_fast_commit_in_existing_filesystems
# tune2fs -O fast_commit /dev/drivepartition

# I/O scheduler
# https://wiki.archlinux.org/index.php/Improving_performance#Changing_I/O_scheduler
sudo tee /etc/udev/rules.d/60-ioschedulers.rules <<EOF
# set scheduler for NVMe
ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
# set scheduler for SSD and eMMC
ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
# set scheduler for rotating disks
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
EOF

sudo udevadm control --reload

### Network
# https://wiki.archlinux.org/index.php/Sysctl
sudo tee /etc/sysctl.d/99-network-performance.conf <<EOF
net.core.netdev_max_backlog = 16384

net.core.somaxconn=8192

net.core.rmem_default = 1048576
net.core.rmem_max = 16777216
net.core.wmem_default = 1048576
net.core.wmem_max = 16777216
net.core.optmem_max = 65536
net.ipv4.tcp_rmem = 4096 1048576 2097152
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.udp_rmem_min = 8192
net.ipv4.udp_wmem_min = 8192

net.ipv4.tcp_fastopen = 3

net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 2000000
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_slow_start_after_idle = 0

net.ipv4.tcp_keepalive_time = 120
net.ipv4.tcp_keepalive_intvl = 20
net.ipv4.tcp_keepalive_probes = 6

net.core.default_qdisc=cake
net.ipv4.tcp_congestion_control=bbr
EOF

# https://wiki.archlinux.org/index.php/Swap#Performance
sudo tee /etc/sysctl.d/99-swap.conf <<EOF
vm.dirty_writeback_centisecs = 6000
vm.swappiness=10
EOF

sudo sysctl --system

### makepkg
sudo sed -i 's/^#MAKEFLAGS="-j2"$/MAKEFLAGS="-j\$(nproc)"/' /etc/makepkg.conf
# not tested
#sudo sed -i 's/-march=x86_64 -mtune=generic/-march=native/' /etc/makepkg.conf

### watchdogs
# (manual) add 'nowatchdog' kernel parameter
# blacklist iTCO_wdt
echo 'blacklist iTCO_wdt' | sudo tee /etc/modprobe.d/blacklist_watchdog.conf
