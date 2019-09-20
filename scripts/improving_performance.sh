#!/bin/bash

# (manual) check partition alignment
# https://wiki.archlinux.org/index.php/Partitioning#Partition_alignment

# (manual) tuning filesystem
# for ext4, add "noatime,commit=60" option to /etc/fstab

# sysctl
# https://wiki.archlinux.org/index.php/Sysctl
# https://wiki.archlinux.org/index.php/Swap#Performance
echo | sudo tee /etc/sysctl.d/99-sysctl.conf <<EOF
net.core.netdev_max_backlog = 100000
net.core.netdev_budget = 50000
net.core.netdev_budget_usecs = 5000

net.core.somaxconn = 1024

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

net.ipv4.tcp_max_syn_backlog = 30000
net.ipv4.tcp_max_tw_buckets = 2000000
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_slow_start_after_idle = 0

net.ipv4.tcp_keepalive_time = 180
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_keepalive_probes = 6

net.ipv4.tcp_mtu_probing = 1

net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr

net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.rp_filter = 1

net.ipv4.tcp_syncookies = 1

net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0

vm.dirty_ratio = 5
vm.dirty_background_ratio = 3
vm.swappiness=10
EOF

sudo sysctl --system

# I/O scheduler
# https://wiki.archlinux.org/index.php/Improving_performance#Changing_I/O_scheduler
echo | sudo tee /etc/udev/rules.d/60-ioschedulers.rules <<EOF
# set scheduler for NVMe
ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
# set scheduler for SSD and eMMC
ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
# set scheduler for rotating disks
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
EOF

sudo udevadm control --reload

# makepkg
sudo sed -i 's/^#MAKEFLAGS="-j2"$/MAKEFLAGS="-j\$(nproc)"/' /etc/makepkg.conf
# not tested
#sudo sed -i 's/-march=x86_64 -mtune=generic/-march=native/' /etc/makepkg.conf
sudo sed -i 's/^PKGEXT='\''\.pkg\.tar\.xz'\''/PKGEXT='\''\.pkg\.tar'\''/' /etc/makepkg.conf

# watchdogs
# (manual) add 'nowatchdog' kernel parameter
# blacklist iTCO_wdt
echo 'blacklist iTCO_wdt' | sudo tee /etc/modprobe.d/blacklist_watchdog.conf
