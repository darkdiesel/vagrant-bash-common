#!/usr/bin/env bash

source /vagrant/configs/constants.conf
source ${VAGRANT_UBUNTU_COMMON_SCRIPTS_PATH}/_bootstrap.sh

log_begin_msg "Update packages"
sudo apt-get update > /dev/null 2>&1
log_end_msg 0

source ${VAGRANT_OS_SCRIPTS_DIR}/dos2unix.sh

log_begin_msg "Convert files to unix format"
sudo find ${VAGRANT_PATH} -type f -print0 | sudo xargs -0 dos2unix > /dev/null 2>&1
log_end_msg 0

# run scripts
source ${VAGRANT_OS_SCRIPTS_DIR}/fix-locale.sh

if [ "PACKAGES_MC" == "YES" ]; then
    source ${VAGRANT_OS_SCRIPTS_DIR}/mc.sh
fi

if [ "PACKAGES_GIT" == "YES" ]; then
    source ${VAGRANT_OS_SCRIPTS_DIR}/git.sh
fi

# web servers
source ${VAGRANT_OS_SCRIPTS_DIR}/apache2.sh
source ${VAGRANT_OS_SCRIPTS_DIR}/nginx.sh

# db
source ${VAGRANT_OS_SCRIPTS_DIR}/mariadb.${DB_MARIADB_VERSION}.sh
source ${VAGRANT_OS_SCRIPTS_DIR}/db-setup.sh

source ${VAGRANT_OS_SCRIPTS_DIR}/php7.2-fpm.sh

if [ "PACKAGES_COMPOSER" == "YES" ]; then
    source ${VAGRANT_OS_SCRIPTS_DIR}/composer.sh
fi

if [ "PACKAGES_DRUSH" == "YES" ]; then
    source ${VAGRANT_OS_SCRIPTS_DIR}/drush.sh
fi