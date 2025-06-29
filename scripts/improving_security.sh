#!/bin/bash

### CPU

# Microcode
# https://wiki.archlinux.org/title/Microcode

# Hardware vulnerabilities
# https://wiki.archlinux.org/title/Security#Hardware_vulnerabilities
lscpu

### Kernel

# https://wiki.archlinux.org/title/Security#Restricting_access_to_kernel_pointers_in_the_proc_filesystem
# This will break some perf commands when used by non-root users.
# sudo tee /etc/sysctl.d/51-kptr-restrict.conf <<EOF
# kernel.kptr_restrict = 1
# EOF

# https://wiki.archlinux.org/title/Security#Restricting_module_loading
# sudo tee /etc/sysctl.d/51-kexec-restrict.conf <<EOF
# kernel.kexec_load_disabled = 1
# EOF

# Restricting module loading
# https://wiki.archlinux.org/title/Security#Restricting_module_loading
# add "module.sig_enforce=1" kernel parameter

### TCP/IP stack hardening
#https://wiki.archlinux.org/title/Sysctl#TCP/IP_stack_hardening
sudo tee /etc/sysctl.d/99-network-security.conf <<EOF
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_rfc1337 = 1

net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.rp_filter = 1

net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0

net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
EOF
