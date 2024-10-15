#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' dirmngr 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing dirmngr" > /dev/null 2>&1

    sudo apt-get install -y dirmngr > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_action_msg "dirmngr already installed"
fi