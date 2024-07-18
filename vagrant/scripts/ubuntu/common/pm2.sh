#!/usr/bin/env bash

# before installation highcharts-export-server you need to install nodejs
source ${VAGRANT__OS_SCRIPTS_PATH}/nodejs.sh


if [ $(npm list -g pm2 2>/dev/null | grep -c "pm2") -eq 1 ]; then
    log_begin_msg "Installing pm2"
    npm install pm2 -g > /dev/null 2>&1
    log_end_msg 0
else
    log_begin_msg "pm2 installed"
    log_end_msg 0
fi

