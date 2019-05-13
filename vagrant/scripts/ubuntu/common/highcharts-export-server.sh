#!/usr/bin/env bash

# before installation highcharts-export-server you need to install nodejs
#source ${VAGRANT__UBUNTU_COMMON_SCRIPTS_PATH}/nodejs.sh


log_begin_msg "Installing node-export-server"
git clone https://github.com/highcharts/node-export-server > /dev/null 2>&1
cd ./node-export-server
ACCEPT_HIGHCHARTS_LICENSE=YES npm install > /dev/null 2>&1
npm link > /dev/null 2>&1

npm install -g forever > /dev/null 2>&1
forever start --killSignal SIGINT ./bin/cli.js --enableServer 1  > /dev/null 2>&1
cd ~
log_end_msg 0