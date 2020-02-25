#!/bin/bash

set -eEu

SS_CONFIG=$1
SS_SERVER=$(cat /etc/shadowsocks/${SS_CONFIG}.json | jq -r .server)
SS_SOCKS5_PORT=$(cat /etc/shadowsocks/${SS_CONFIG}.json | jq -r .local_port)

sysctl net.ipv4.ip_forward=1
systemctl restart iptables.service

set_iptables() {
    iptables -t nat -N SHADOWSOCKS
    iptables -t mangle -N SHADOWSOCKS

    # Ignore your shadowsocks server's addresses
    # It's very IMPORTANT, just be careful.
    iptables -t nat -A SHADOWSOCKS -d $SS_SERVER -j RETURN
    iptables -t mangle -A SHADOWSOCKS -d $SS_SERVER -j RETURN

    # Ignore LANs and any other addresses you'd like to bypass the proxy
    iptables -t nat -A SHADOWSOCKS -d 0.0.0.0/8 -j RETURN
    iptables -t nat -A SHADOWSOCKS -d 10.0.0.0/8 -j RETURN
    iptables -t nat -A SHADOWSOCKS -d 127.0.0.0/8 -j RETURN
    iptables -t nat -A SHADOWSOCKS -d 169.254.0.0/16 -j RETURN
    iptables -t nat -A SHADOWSOCKS -d 172.16.0.0/12 -j RETURN
    iptables -t nat -A SHADOWSOCKS -d 192.168.0.0/16 -j RETURN
    iptables -t nat -A SHADOWSOCKS -d 224.0.0.0/4 -j RETURN
    iptables -t nat -A SHADOWSOCKS -d 240.0.0.0/4 -j RETURN

    # Anything else should be redirected to shadowsocks's local port
    iptables -t nat -A SHADOWSOCKS -p tcp -j REDIRECT --to-ports $SS_SOCKS5_PORT

    # Add any UDP rules
    ip route add local default dev lo table 100
    ip rule add fwmark 1 lookup 100
    iptables -t mangle -A SHADOWSOCKS -p udp --dport 53 -j TPROXY --on-port $SS_SOCKS5_PORT --tproxy-mark 0x01/0x01

    # Apply the rules
    iptables -t nat -A PREROUTING -p tcp -j SHADOWSOCKS
    iptables -t nat -A OUTPUT -p tcp -j SHADOWSOCKS
    iptables -t mangle -A PREROUTING -j SHADOWSOCKS
}

restore() {
    systemctl restart iptables.service
    systemctl restart "shadowsocks-libev@${SS_CONFIG}"
    ip rule delete fwmark 1 lookup 100
    ip route delete local default dev lo table 100
}

trap 'restore' EXIT

set_iptables

systemctl stop "shadowsocks-libev@${SS_CONFIG}"
ss-redir -c "/etc/shadowsocks/${SS_CONFIG}.json"
