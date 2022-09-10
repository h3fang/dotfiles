#!/bin/sh

nohup systemd-inhibit --what=handle-lid-switch --who="$USER" --why="Prevent suspend on lid close" --mode=block /usr/bin/bash -c "while true; do sleep 60; done" > /dev/null 2>&1 &

