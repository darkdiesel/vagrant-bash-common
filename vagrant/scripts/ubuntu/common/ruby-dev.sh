#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' ruby-dev 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing ruby-dev"
    sudo apt-get install -y ruby-dev > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_action_msg "ruby-dev already installed"
fi