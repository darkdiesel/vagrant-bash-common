#!/usr/bin/env bash

MARIADB_LIST="mariadb.list"
MARIADB_APT_SOURCE_LIST="/etc/apt/sources.list.d/"${MARIADB_LIST}
VAGRANT_APT_SOURCE=${VAGRANT__OS_CONFIGS_PATH}"/etc/apt/sources.list.d/mariadb.10.2.list"

log_begin_msg "Adding mariadb sources list"
if [ -f $MARIADB_APT_SOURCE_LIST ]; then
    sudo rm -rf $MARIADB_APT_SOURCE_LIST
fi

if [ -f $VAGRANT_APT_SOURCE ]; then
    sudo cp -R $VAGRANT_APT_SOURCE $MARIADB_APT_SOURCE_LIST > /dev/null 2>&1
else
    sudo touch $MARIADB_APT_SOURCE_LIST

    sudo chmod 777 $MARIADB_APT_SOURCE_LIST

    sudo echo "deb [arch=amd64,i386,ppc64el] http://mirror.hosting90.cz/mariadb/repo/10.2/debian stretch main" >> $MARIADB_APT_SOURCE_LIST
    sudo echo "deb-src http://mirror.hosting90.cz/mariadb/repo/10.2/debian stretch main" >> $MARIADB_APT_SOURCE_LIST

    sudo chmod 755 $MARIADB_APT_SOURCE_LIST
fi
log_end_msg 0

log_action_msg "Installing additional required packages"

source ${VAGRANT__OS_SCRIPTS_PATH}/software-properties-common.sh
source ${VAGRANT__OS_SCRIPTS_PATH}/dirmngr.sh

log_begin_msg "Adding mariadb key"
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xF1656F24C74CD1D8 > /dev/null 2>&1
log_end_msg 0

log_begin_msg "Update packages list"
sudo apt-get update > /dev/null 2>&1
log_end_msg 0

if [ $(dpkg-query -W -f='${Status}' mariadb-server 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing mariadb-server"

    sudo debconf-set-selections <<< "mariadb-server mysql-server/root_password password $DB__PASS"
    sudo debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password $DB__PASS"

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

if [ $(dpkg-query -W -f='${Status}' mariadb-client 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing mariadb-client"

    sudo apt-get install -y mariadb-client > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_begin_msg "mariadb-client installed"
    log_end_msg 0
fi

DEBIAN_SYS_MAINT_USER=$(grep 'user' /etc/mysql/debian.cnf | head -1 | awk '{print $3}')
DEBIAN_SYS_MAINT_PASS=$(grep 'password' /etc/mysql/debian.cnf | head -1 | awk '{print $3}')

sudo mysql -u$DB__USER -p$DB__PASS -e 'GRANT ALL PRIVILEGES ON *.* TO "'$DEBIAN_SYS_MAINT_USER'"@"localhost" IDENTIFIED BY "'$DEBIAN_SYS_MAINT_PASS'";'
sudo mysql -u$DB__USER -p$DB__PASS -e "FLUSH PRIVILEGES;"