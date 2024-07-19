#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' apt-transport-https 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing apt-transport-https"

    sudo apt-get install -y apt-transport-https > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_progress_msg "apt-transport-https already installed"
fi