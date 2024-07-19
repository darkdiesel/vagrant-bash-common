#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' dos2unix 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing dos2unix"
    sudo apt-get install -y dos2unix > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_progress_msg "dos2unix already installed"
fi