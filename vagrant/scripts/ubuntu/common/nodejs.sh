#!/usr/bin/env bash


if [ $(nvm --help 2>/dev/null | grep -c "Node Version Manager") -eq 0 ]; then
    log_progress_msg "nvm not installed"
else
    log_progress_msg "nvm already installed"
fi


if [ $(dpkg-query -W -f='${Status}' nodejs 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    if [ -n "$PACKAGES__NODEJS__VERSION" ]; then
        eval NODEJS_VERSION='$PACKAGES__NODEJS__VERSION';
    else
        NODEJS_VERSION='20'
    fi;

    log_begin_msg "Installing nodejs ${NODEJS_VERSION}"
    curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | sudo -E bash - > /dev/null 2>&1

    sudo apt-get install -y nodejs > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_progress_msg "nodejs already installed"
fi