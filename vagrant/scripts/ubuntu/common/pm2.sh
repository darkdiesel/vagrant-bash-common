#!/usr/bin/env bash

source ${VAGRANT__OS_SCRIPTS_PATH}/npm.sh

if [ $(npm list -g pm2 2>/dev/null | grep -c "pm2") -eq 0 ]; then
    log_begin_msg "Installing pm2"
    sudo npm install pm2 -g > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_action_msg "pm2 already installed"
fi

