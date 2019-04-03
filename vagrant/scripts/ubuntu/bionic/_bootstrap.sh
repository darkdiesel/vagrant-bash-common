#!/usr/bin/env bash

source /vagrant/scripts/ubuntu/common/_bootstrap.sh

log_begin_msg "Update packages"
sudo apt-get update > /dev/null 2>&1
log_end_msg 0

source ${VAGRANT_OS_SCRIPTS_PATH}/dos2unix.sh

log_begin_msg "Convert files to unix format"
sudo find ${VAGRANT_PATH} -type f -print0 | sudo xargs -0 dos2unix > /dev/null 2>&1
log_end_msg 0

# run scripts
source ${VAGRANT_OS_SCRIPTS_PATH}/fix-locale.sh

if [ ${PACKAGES_MC} == "YES" ]; then
    source ${VAGRANT_OS_SCRIPTS_PATH}/mc.sh
fi

if [ ${PACKAGES_GIT} == "YES" ]; then
    source ${VAGRANT_OS_SCRIPTS_PATH}/git.sh
fi

# web servers
source ${VAGRANT_OS_SCRIPTS_PATH}/apache2.sh
source ${VAGRANT_OS_SCRIPTS_PATH}/nginx.sh

# db
source ${VAGRANT_OS_SCRIPTS_PATH}/mariadb.${DB_MARIADB_VERSION}.sh
source ${VAGRANT_OS_SCRIPTS_PATH}/db-setup.sh

source ${VAGRANT_OS_SCRIPTS_PATH}/php7.2-fpm.sh

if [ ${PACKAGES_COMPOSER} == "YES" ]; then
    source ${VAGRANT_OS_SCRIPTS_PATH}/composer.sh
fi
if [ ${PACKAGES_SENDMAIL} == "YES" ]; then
    source ${VAGRANT_OS_SCRIPTS_PATH}/sendmail.sh
fi

if [ ${PACKAGES_PHPMYADMIN} == "YES" ]; then
    source ${VAGRANT_OS_SCRIPTS_PATH}/phpmyadmin.sh
fi

if [ ${PACKAGES_MAILCATCHER} == "YES" ]; then
    source ${VAGRANT_OS_SCRIPTS_PATH}/mailcatcher.sh
fi

if [ ${PACKAGES_DRUSH} == "YES" ]; then
    source ${VAGRANT_OS_SCRIPTS_PATH}/drush.sh
fi