#!/usr/bin/env bash

source /vagrant/scripts/ubuntu/common/_bootstrap.sh

log_begin_msg "Update packages"
sudo apt-get update > /dev/null 2>&1
log_end_msg 0

source ${VAGRANT__OS_SCRIPTS_PATH}/dos2unix.sh

log_begin_msg "Convert files to unix format"
sudo find ${VAGRANT__PATH} -type f -print0 | sudo xargs -0 dos2unix > /dev/null 2>&1
log_end_msg 0

# run scripts
source ${VAGRANT__OS_SCRIPTS_PATH}/fix-locale.sh
source ${VAGRANT__OS_SCRIPTS_PATH}/curl.sh

if [ ${PACKAGES__MC} == "YES" ]; then
    source ${VAGRANT__OS_SCRIPTS_PATH}/mc.sh
fi

if [ ${PACKAGES__HTOP} == "YES" ]; then
    source ${VAGRANT__OS_SCRIPTS_PATH}/htop.sh
fi

if [ ${PACKAGES__GIT} == "YES" ]; then
    source ${VAGRANT__OS_SCRIPTS_PATH}/git.sh
fi

if [ ${PACKAGES__VIM} == "YES" ]; then
    source ${VAGRANT__OS_SCRIPTS_PATH}/vim.sh
fi

# web servers
source ${VAGRANT__OS_SCRIPTS_PATH}/apache2.sh
source ${VAGRANT__OS_SCRIPTS_PATH}/nginx.sh

# db
if [ ${PACKAGES__MARIADB__INSTALL} == "YES" ]; then
    source ${VAGRANT__OS_SCRIPTS_PATH}/mariadb.${PACKAGES__MARIADB__VERSION}.sh
    source ${VAGRANT__OS_SCRIPTS_PATH}/db-setup.sh
fi

if [ ${PACKAGES__PHP__INSTALL} == "YES" ]; then
    source ${VAGRANT__OS_SCRIPTS_PATH}/php5.sh
fi

if [ ${PACKAGES__COMPOSER} == "YES" ]; then
    source ${VAGRANT__OS_SCRIPTS_PATH}/composer.sh
fi

if [ ${PACKAGES__SENDMAIL} == "YES" ]; then
    source ${VAGRANT__OS_SCRIPTS_PATH}/sendmail.sh
fi

if [ ${PACKAGES__PHPMYADMIN} == "YES" ]; then
    source ${VAGRANT__OS_SCRIPTS_PATH}/phpmyadmin.sh
fi

if [ ${PACKAGES__MAILCATCHER} == "YES" ]; then
    source ${VAGRANT__OS_SCRIPTS_PATH}/mailcatcher.sh
fi