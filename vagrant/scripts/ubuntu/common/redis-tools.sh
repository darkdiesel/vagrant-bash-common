#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' redis-tools 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing redis-tools"
    sudo apt-get install -y redis-tools > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_action_msg "redis-tools already installed"
fi