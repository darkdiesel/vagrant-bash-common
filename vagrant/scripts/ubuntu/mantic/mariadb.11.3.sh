#!/usr/bin/env bash

MARIADB_LIST="mariadb.list"
MARIADB_APT_SOURCE_LIST="/etc/apt/sources.list.d/"${MARIADB_LIST}
VAGRANT_APT_SOURCE=${VAGRANT__OS_CONFIGS_PATH}"/etc/apt/sources.list.d/mariadb.11.4.list"

log_begin_msg "Adding mariadb sources list"
if [ -f $MARIADB_APT_SOURCE_LIST ]; then
    sudo rm -rf $MARIADB_APT_SOURCE_LIST
fi

if [ -f $VAGRANT_APT_SOURCE ]; then
    sudo cp -R $VAGRANT_APT_SOURCE $MARIADB_APT_SOURCE_LIST > /dev/null 2>&1
else
    sudo touch $MARIADB_APT_SOURCE_LIST

    sudo chmod 777 $MARIADB_APT_SOURCE_LIST

    sudo echo "deb [signed-by=/usr/share/keyrings/mariadb-keyring.pgp] https://deb.mariadb.org/11.4/debian bullseye main" >> $MARIADB_APT_SOURCE_LIST
    sudo echo "deb-src [signed-by=/usr/share/keyrings/mariadb-keyring.pgp] https://mirrors.ircam.fr/pub/mariadb/repo/11.4/debian bullseye main" >> $MARIADB_APT_SOURCE_LIST

    sudo chmod 755 $MARIADB_APT_SOURCE_LIST
fi
log_end_msg 0

log_action_msg "Installing additional required packages"

source ${VAGRANT__OS_SCRIPTS_PATH}/curl.sh
source ${VAGRANT__OS_SCRIPTS_PATH}/apt-transport-https.sh

log_begin_msg "Adding mariadb key"
sudo mkdir -p /etc/apt/keyrings
sudo curl -o /usr/share/keyrings/mariadb-keyring.pgp 'https://mariadb.org/mariadb_release_signing_key.pgp' > /dev/null 2>&1
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

if [ $(dpkg-query -W -f='${Status}' mariadb-server 2>/dev/null | grep -c "ok installed") -eq 1 ]; then

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | sudo mariadb-secure-installation
      # current root password (empty after installation)
    n # Switch to unix_socket authentication
    y # Set root password?
    ${DB__PASS} # new root password
    ${DB__PASS} # new root password
    y # Remove anonymous users?
    y # Disallow root login remotely?
    y # Remove test database and access to it?
    y # Reload privilege tables now?
EOF

fi

#DEBIAN_SYS_MAIN_USER=$(grep 'user' /etc/mysql/debian.cnf | head -1 | awk '{print $3}')
#DEBIAN_SYS_MAIN_PASS=$(grep 'password' /etc/mysql/debian.cnf | head -1 | awk '{print $3}')

#sudo mysql -u$DB__USER -p$DB__PASS -e 'GRANT ALL PRIVILEGES ON *.* TO "'$DEBIAN_SYS_MAIN_USER'"@"localhost" IDENTIFIED BY "'$DEBIAN_SYS_MAIN_PASS'";'
#sudo mysql -u$DB__USER -p$DB__PASS -e "FLUSH PRIVILEGES;"