#!/bin/bash
# requires clash, iptables, iproute2, systemd

set -eETu -o pipefail

trap 'echo "ERROR on line: ${LINENO}", command: "$BASH_COMMAND"' ERR

clear_iptables() {
    iptables -F
    iptables -X
    iptables -t nat -F
    iptables -t nat -X
    iptables -t mangle -F
    iptables -t mangle -X
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT
}

restore() {
    set +eET
    echo resetting ...
    clear_iptables
    systemctl stop iptables.service
    ip rule delete fwmark ${fwmark} table ${table_id}
    ip route del local 0.0.0.0/0 dev lo table ${table_id}
}

trap restore EXIT

### configuration

table_id=127
fwmark=${table_id}
clash_tproxy_port=7893
clash_dns=1053

ip rule add fwmark ${fwmark} lookup ${table_id}
ip route add local 0.0.0.0/0 dev lo table ${table_id}

sysctl net.ipv4.ip_forward=1

systemctl start iptables.service

# 处理转发流量
iptables -t mangle -N CLASH

iptables -t mangle -A CLASH -d 0.0.0.0/8 -j RETURN
iptables -t mangle -A CLASH -d 10.0.0.0/8 -j RETURN
iptables -t mangle -A CLASH -d 127.0.0.0/8 -j RETURN
iptables -t mangle -A CLASH -d 169.254.0.0/16 -j RETURN
iptables -t mangle -A CLASH -d 172.16.0.0/12 -j RETURN
iptables -t mangle -A CLASH -d 192.168.0.0/16 -j RETURN
iptables -t mangle -A CLASH -d 224.0.0.0/4 -j RETURN
iptables -t mangle -A CLASH -d 240.0.0.0/4 -j RETURN

iptables -t mangle -A CLASH -p udp -m udp --dport 53 -j RETURN

iptables -t mangle -A CLASH -p tcp -j TPROXY --on-port ${clash_tproxy_port} --tproxy-mark ${fwmark}
iptables -t mangle -A CLASH -p udp -j TPROXY --on-port ${clash_tproxy_port} --tproxy-mark ${fwmark}

iptables -t mangle -A PREROUTING -j CLASH
iptables -t nat -I PREROUTING -p udp -m udp --dport 53 -j REDIRECT --to-ports ${clash_dns}

# 处理本机流量
iptables -t mangle -N CLASH_LOCAL

iptables -t mangle -A CLASH_LOCAL -d 0.0.0.0/8 -j RETURN
iptables -t mangle -A CLASH_LOCAL -d 10.0.0.0/8 -j RETURN
iptables -t mangle -A CLASH_LOCAL -d 127.0.0.0/8 -j RETURN
iptables -t mangle -A CLASH_LOCAL -d 169.254.0.0/16 -j RETURN
iptables -t mangle -A CLASH_LOCAL -d 172.16.0.0/12 -j RETURN
iptables -t mangle -A CLASH_LOCAL -d 192.168.0.0/16 -j RETURN
iptables -t mangle -A CLASH_LOCAL -d 224.0.0.0/4 -j RETURN
iptables -t mangle -A CLASH_LOCAL -d 240.0.0.0/4 -j RETURN

iptables -t mangle -A CLASH_LOCAL -p tcp -m owner --uid-owner clash -j RETURN
iptables -t mangle -A CLASH_LOCAL -p udp -m owner --uid-owner clash -j RETURN
iptables -t mangle -A CLASH_LOCAL -p udp -m udp --dport 53 -j RETURN

iptables -t mangle -A CLASH_LOCAL -p tcp -j MARK --set-mark ${fwmark}
iptables -t mangle -A CLASH_LOCAL -p udp -j MARK --set-mark ${fwmark}

iptables -t nat -A OUTPUT -m owner --uid-owner clash -j RETURN
iptables -t nat -A OUTPUT -p udp -m udp --dport 53 -j REDIRECT --to-ports ${clash_dns}

iptables -t mangle -A OUTPUT -j CLASH_LOCAL

# 修复 ICMP(ping)
# 这并不能保证 ping 结果有效(clash 等不支持转发 ICMP), 只是让它有返回结果而已
# --to-destination 设置为一个可达的地址即可
sysctl net.ipv4.conf.all.route_localnet=1
iptables -t nat -A PREROUTING -p icmp -d 198.18.0.1/16 -j DNAT --to-destination 127.0.0.1
iptables -t nat -A OUTPUT -p icmp -d 198.18.0.1/16 -j DNAT --to-destination 127.0.0.1

