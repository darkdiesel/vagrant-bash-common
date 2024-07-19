#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' libsqlite3-dev 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing libsqlite3-dev"
    sudo apt-get install -y libsqlite3-dev > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_progress_msg "libsqlite3-dev already installed"
fi