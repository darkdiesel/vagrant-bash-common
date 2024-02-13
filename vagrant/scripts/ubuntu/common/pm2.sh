#!/usr/bin/env bash

# before installation highcharts-export-server you need to install nodejs
source ${VAGRANT__OS_SCRIPTS_PATH}/nodejs.sh

log_begin_msg "Installing pm2"
npm install pm2 -g > /dev/null 2>&1
log_end_msg 0