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

if [ ${PACKAGES__MC} == "YES" ]; then
    source ${VAGRANT__OS_SCRIPTS_PATH}/mc.sh
fi

if [ ${PACKAGES__GIT} == "YES" ]; then
    source ${VAGRANT__OS_SCRIPTS_PATH}/git.sh
fi

## web servers
source ${VAGRANT__OS_SCRIPTS_PATH}/apache2.sh
source ${VAGRANT__OS_SCRIPTS_PATH}/nginx.sh

## db
#source ${VAGRANT__OS_SCRIPTS_PATH}/mariadb.${DB__MARIADB_VERSION}.sh
#source ${VAGRANT__OS_SCRIPTS_PATH}/db-setup.sh
#
#source ${VAGRANT__OS_SCRIPTS_PATH}/php7.2-fpm.sh
#
#if [ ${PACKAGES__COMPOSER} == "YES" ]; then
#    source ${VAGRANT__OS_SCRIPTS_PATH}/composer.sh
#fi
#if [ ${PACKAGES__SENDMAIL} == "YES" ]; then
#    source ${VAGRANT__OS_SCRIPTS_PATH}/sendmail.sh
#fi
#
#if [ ${PACKAGES__PHPMYADMIN} == "YES" ]; then
#    source ${VAGRANT__OS_SCRIPTS_PATH}/phpmyadmin.sh
#fi
#
#if [ ${PACKAGES__MAILHOG} == "YES" ]; then
#    source ${VAGRANT__OS_SCRIPTS_PATH}/mailhog.sh
#fi
#
#if [ ${PACKAGES__MAILCATCHER} == "YES" ]; then
#    source ${VAGRANT__OS_SCRIPTS_PATH}/mailcatcher.sh
#fi
#
#if [ ${PACKAGES__DRUSH} == "YES" ]; then
#    source ${VAGRANT__OS_SCRIPTS_PATH}/drush.sh
#fi