#!/usr/bin/env bash

MARIADB_LIST="mariadb.list"
MARIADB_APT_SOURCE_LIST="/etc/apt/sources.list.d/"${MARIADB_LIST}
VAGRANT_APT_SOURCE=${VAGRANT_OS_CONFIGS_DIR}"/etc/apt/sources.list.d/mariadb.10.3.list"

log_begin_msg "Adding mariadb sources list"
if [ -f $MARIADB_APT_SOURCE_LIST ]; then
    sudo rm -rf $MARIADB_APT_SOURCE_LIST
fi

if [ -f $VAGRANT_APT_SOURCE ]; then
    sudo cp -R $VAGRANT_APT_SOURCE $MARIADB_APT_SOURCE_LIST > /dev/null 2>&1
else
    sudo touch $MARIADB_APT_SOURCE_LIST

    sudo chmod 777 $MARIADB_APT_SOURCE_LIST

    sudo echo "deb [arch=amd64,arm64,ppc64el] http://mirror.hosting90.cz/mariadb/repo/10.3/ubuntu bionic main" >> $MARIADB_APT_SOURCE_LIST
    sudo echo "deb-src http://mirror.hosting90.cz/mariadb/repo/10.3/ubuntu bionic main" >> $MARIADB_APT_SOURCE_LIST

    sudo chmod 755 $MARIADB_APT_SOURCE_LIST
fi
log_end_msg 0

log_action_msg "Installing additional required packages"

source ${VAGRANT_OS_SCRIPTS_DIR}/software-properties-common.sh
#source ${VAGRANT_OS_SCRIPTS_DIR}/dirmngr.sh

log_begin_msg "Adding mariadb key"
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 > /dev/null 2>&1
log_end_msg 0

log_begin_msg "Update packages list"
sudo apt-get update > /dev/null 2>&1
log_end_msg 0

if [ $(dpkg-query -W -f='${Status}' mariadb-server 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing mariadb-server"

    sudo debconf-set-selections <<< "mariadb-server mysql-server/root_password password $DB_PASS"
    sudo debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password $DB_PASS"

    sudo apt-get install -y mariadb-server > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
#        sudo systemctl start mariadb.service
#        sudo systemctl enable mariadb.service
        log_end_msg 0
    fi
else
    log_begin_msg "mariadb-server installed"
    log_end_msg 0
fi