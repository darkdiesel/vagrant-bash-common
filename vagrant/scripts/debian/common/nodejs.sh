#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' nodejs 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    if [ -n "$PACKAGES__NODEJS__VERSION" ]; then
        eval NODEJS_VERSION='$PACKAGES__NODEJS__VERSION';
    else
        NODEJS_VERSION='10'
    fi;

    log_begin_msg "Installing nodejs"
    curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | sudo bash - > /dev/null 2>&1

    sudo apt-get install -y nodejs > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_begin_msg "nodejs installed"
    log_end_msg 0
fi