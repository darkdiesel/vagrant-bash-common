#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' redis-server 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing redis-server"
    sudo apt-get install -y redis-server > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_action_msg "redis-server already installed"
fi