#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' htop 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing htop"
    sudo apt-get install -y htop > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_begin_msg "htop installed"
    log_end_msg 0
fi