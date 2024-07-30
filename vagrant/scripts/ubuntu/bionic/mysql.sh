#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing mysql-server"

    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB__PASS"
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB__PASS"

    sudo apt-get install -y mysql-server

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
#        sudo systemctl start mariadb.service
#        sudo systemctl enable mariadb.service
        log_end_msg 0
    fi
else
    log_progress_msg "mysql-server already installed"
fi

if [ $(dpkg-query -W -f='${Status}' mysql-client 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing mysql-client"

    sudo apt-get install -y mysql-client > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_progress_msg "mysql-client already installed"
fi

DEBIAN_SYS_MAIN_USER=$(grep 'user' /etc/mysql/debian.cnf | head -1 | awk '{print $3}')
DEBIAN_SYS_MAIN_PASS=$(grep 'password' /etc/mysql/debian.cnf | head -1 | awk '{print $3}')

sudo mysql -u$DB__USER -p$DB__PASS -e 'GRANT ALL PRIVILEGES ON *.* TO "'$DEBIAN_SYS_MAIN_USER'"@"localhost" IDENTIFIED BY "'$DEBIAN_SYS_MAIN_PASS'";'
sudo mysql -u$DB__USER -p$DB__PASS -e "FLUSH PRIVILEGES;"