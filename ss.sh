#!/bin/sh

pkill ss-local
nohup ss-local -c ~/.shadowsocks-libev/config.json >/dev/null 2>&1 &
