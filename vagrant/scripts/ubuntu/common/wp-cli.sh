#!/usr/bin/env bash

source ${VAGRANT__OS_SCRIPTS_PATH}/curl.sh

log_begin_msg "Installing wp cli"
sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /dev/null 2>&1
sudo chmod +x wp-cli.phar > /dev/null 2>&1
sudo mv wp-cli.phar /usr/local/bin/wp > /dev/null 2>&1
log_end_msg 0
