#!/usr/bin/env bash

. /lib/lsb/init-functions

# only official box names
VAGRANT_OS="ubuntu/trusty"

source /vagrant/settings.conf

log_begin_msg "Update packages"
sudo apt-get update > /dev/null 2>&1
log_end_msg 0

source ${VAGRANT_SCRIPTS}/dos2unix.sh

log_begin_msg "Update privileges for scripts"
sudo chmod +x ${VAGRANT_SCRIPTS}/*.sh
log_end_msg 0

log_begin_msg "Convert to unix format scripts"
sudo dos2unix ${VAGRANT_FOLDER}/bootstrap.sh  > /dev/null 2>&1
sudo dos2unix ${VAGRANT_SCRIPTS}/*.sh  > /dev/null 2>&1
log_end_msg 0

log_begin_msg "Convert to unix format configs"
sudo find ${VAGRANT_CONFIGS} -type f -print0 | sudo xargs -0 dos2unix > /dev/null 2>&1
log_end_msg 0

# run scripts
source ${VAGRANT_SCRIPTS}/fix-locale.sh
source ${VAGRANT_SCRIPTS}/mc.sh
source ${VAGRANT_SCRIPTS}/htop.sh
source ${VAGRANT_SCRIPTS}/git.sh
source ${VAGRANT_SCRIPTS}/vim.sh

# web servers
source ${VAGRANT_SCRIPTS}/apache2.sh
source ${VAGRANT_SCRIPTS}/nginx.sh

# db
source ${VAGRANT_SCRIPTS}/mariadb.${MARIADB_VERSION}.sh