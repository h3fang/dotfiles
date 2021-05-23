#!/bin/bash
# requires clash, tun2socks, iptables, pcre, iproute2, procps-ng, systemd

set -eETu -o pipefail

trap 'echo "ERROR on line: ${LINENO}", command: "$BASH_COMMAND"' ERR

restore() {
    set +eET
    echo resetting ...
    systemctl restart iptables.service
    ip rule delete fwmark ${fwmark}
    ip link set ${tun_dev} down
    ip link delete ${tun_dev}
}

trap restore EXIT

### configuration

# default should be fine
tun_dev=clash0
tun_addr=172.31.255.253/30
tun2socks_addr=172.31.255.254
tun2socks_gateway=172.31.255.253
tun2socks_mask=255.255.255.252
table_id=127
fwmark=127

# change these accordingly
clash_socks5_addr=127.0.0.1
clash_socks5_port=7891
clash_dns=1053
clash_cgroup=$(pcregrep -o1 '0::/(.*)' < /proc/"$(pidof -s clash)"/cgroup)

### end of configuration

ip tuntap add ${tun_dev} mode tun user "$USER"
ip link set ${tun_dev} up
ip address replace ${tun_addr} dev ${tun_dev}
ip route replace default dev ${tun_dev} table ${table_id}
ip rule add fwmark ${fwmark} lookup ${table_id}
sysctl net.ipv4.conf.${tun_dev}.rp_filter=0

iptables -t mangle -N CLASH
iptables -t mangle -A CLASH -d 0.0.0.0/8 -j RETURN
iptables -t mangle -A CLASH -d 10.0.0.0/8 -j RETURN
iptables -t mangle -A CLASH -d 127.0.0.0/8 -j RETURN
iptables -t mangle -A CLASH -d 169.254.0.0/16 -j RETURN
iptables -t mangle -A CLASH -d 172.16.0.0/12 -j RETURN
iptables -t mangle -A CLASH -d 192.168.0.0/16 -j RETURN
iptables -t mangle -A CLASH -d 224.0.0.0/4 -j RETURN
iptables -t mangle -A CLASH -d 240.0.0.0/4 -j RETURN
iptables -t mangle -A CLASH -j MARK --set-mark ${fwmark}

iptables -t mangle -A PREROUTING -j CLASH

iptables -t mangle -A OUTPUT -m cgroup --path "${clash_cgroup}" -j RETURN
iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports ${clash_dns}
iptables -t mangle -A OUTPUT -j CLASH

ulimit -n 65535
tun2socks -device ${tun_dev} -proxy socks5://${clash_socks5_addr}:${clash_socks5_port} -loglevel warn

