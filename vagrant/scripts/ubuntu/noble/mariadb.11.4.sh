#!/usr/bin/env bash

MARIADB_LIST="mariadb.sources"
MARIADB_APT_SOURCE_LIST="/etc/apt/sources.list.d/"${MARIADB_LIST}
VAGRANT_APT_SOURCE=${VAGRANT__OS_CONFIGS_PATH}"/etc/apt/sources.list.d/mariadb.11.4.sources"

log_begin_msg "Adding mariadb sources list"
if [ -f $MARIADB_APT_SOURCE_LIST ]; then
    sudo rm -rf $MARIADB_APT_SOURCE_LIST
fi

if [ -f $VAGRANT_APT_SOURCE ]; then
    sudo cp -R $VAGRANT_APT_SOURCE $MARIADB_APT_SOURCE_LIST > /dev/null 2>&1
else
    sudo touch $MARIADB_APT_SOURCE_LIST

    sudo chmod 777 $MARIADB_APT_SOURCE_LIST

    sudo echo "deb [signed-by=/etc/apt/keyrings/mariadb-keyring.pgp] https://mirror.docker.ru/mariadb/repo/11.4/ubuntu noble main" >> $MARIADB_APT_SOURCE_LIST
    sudo echo "deb-src [signed-by=/etc/apt/keyrings/mariadb-keyring.pgp] https://mirror.docker.ru/mariadb/repo/11.4/ubuntu noble main" >> $MARIADB_APT_SOURCE_LIST

    sudo chmod 755 $MARIADB_APT_SOURCE_LIST
fi
log_end_msg 0

log_action_msg "Installing additional required packages"

source ${VAGRANT__OS_SCRIPTS_PATH}/curl.sh
source ${VAGRANT__OS_SCRIPTS_PATH}/apt-transport-https.sh

log_begin_msg "Adding mariadb key"
sudo mkdir -p /etc/apt/keyrings
sudo curl -o /etc/apt/keyrings/mariadb-keyring.pgp 'https://mariadb.org/mariadb_release_signing_key.pgp' > /dev/null 2>&1
log_end_msg 0

log_begin_msg "Update packages list"
sudo apt-get update > /dev/null 2>&1
log_end_msg 0

if [ $(dpkg-query -W -f='${Status}' mariadb-server 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing mariadb-server"

#    sudo debconf-set-selections <<< "mariadb-server mysql-server/root_password password $DB__PASS"
#    sudo debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password $DB__PASS"

    sudo apt-get install -y mariadb-server > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
#        sudo systemctl start mariadb.service
#        sudo systemctl enable mariadb.service
        log_end_msg 0
    fi
else
    log_action_msg "mariadb-server already installed"
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
    log_action_msg "mariadb-client already installed"
fi

execute_query "SET PASSWORD FOR root@localhost = '${DB__PASS}';"
execute_query "FLUSH PRIVILEGES;"

source ${VAGRANT__OS_SCRIPTS_PATH}/expect.sh

SECURE_MYSQL=$(expect -c "

set timeout 3
spawn mariadb-secure-installation

expect \"Enter current password for root (enter for none):\"
send \"\r\"

expect \"Switch to unix_socket authentication\"
send \"y\r\"

expect \"root password?\"
send \"y\r\"

expect \"New password:\"
send \"$DB__PASS\r\"

expect \"Re-enter new password:\"
send \"$DB__PASS\r\"

expect \"Remove anonymous users?\"
send \"y\r\"

expect \"Disallow root login remotely?\"
send \"y\r\"

expect \"Remove test database and access to it?\"
send \"y\r\"

expect \"Reload privilege tables now?\"
send \"y\r\"

expect eof
")

echo "${SECURE_MYSQL}"