#!/bin/sh

# Google's public IPV6 DNS resolves wrong IPs for Douyu and Netease Cloud Music, resolve them with Chinese DNS server

ETC_HOSTS=/etc/hosts
NAME_SERVER=119.29.29.29

add() {
    HOSTNAME=$1
    IP="$(host $1 $NAME_SERVER | awk '/has address/ { print $4; exit }')"
    HOST_LINE="$IP\t$HOSTNAME"
    if [ -n "$(grep $HOSTNAME /etc/hosts)" ]; then
        sudo sed -i "/$HOSTNAME/d" $ETC_HOSTS
    fi

    echo -e "$HOST_LINE" >> $ETC_HOSTS
    #sleep .5
}

remove() {
    HOSTNAME=$1
    if [ -n "$(grep $HOSTNAME /etc/hosts)" ]; then
        sudo sed -i "/$HOSTNAME/d" $ETC_HOSTS
    fi
}

up() {
    add "www.douyu.com"
    add "apic.douyucdn.cn"
    add "rpic.douyucdn.cn"
    add "static.fengkongcloud.com"
    add "shark.douyucdn.cn"
    add "staticlive.douyucdn.cn"
    
    add "s2.music.126.net"
    add "s3.music.126.net"
    add "s4.music.126.net"

    add "m1.music.126.net"
    add "m2.music.126.net"
    add "m3.music.126.net"
    add "m4.music.126.net"
    add "m5.music.126.net"
    add "m6.music.126.net"
    add "m7.music.126.net"
    add "m8.music.126.net"
    add "m9.music.126.net"
    add "m10.music.126.net"
}

down() {
    remove "www.douyu.com"
    remove "apic.douyucdn.cn"
    remove "rpic.douyucdn.cn"
    remove "static.fengkongcloud.com"
    remove "shark.douyucdn.cn"
    remove "staticlive.douyucdn.cn"

    remove "s2.music.126.net"
    remove "s3.music.126.net"
    remove "s4.music.126.net"

    remove "m1.music.126.net"
    remove "m2.music.126.net"
    remove "m3.music.126.net"
    remove "m4.music.126.net"
    remove "m5.music.126.net"
    remove "m6.music.126.net"
    remove "m7.music.126.net"
    remove "m8.music.126.net"
    remove "m9.music.126.net"
    remove "m10.music.126.net"
}

$@
