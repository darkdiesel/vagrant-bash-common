#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' mysql-server-8.0 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing mysql-server-8.0"

    #sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB__PASS"
    #sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB__PASS"

    sudo apt-get install -y mysql-server-8.0 > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
#        sudo systemctl start mariadb.service
#        sudo systemctl enable mariadb.service
        log_end_msg 0
    fi
else
  log_progress_msg "mysql-server-8.0 already installed"
fi

if [ $(dpkg-query -W -f='${Status}' mysql-client 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing mysql-client-8.0"

    sudo apt-get install -y mysql-client-8.0 > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_progress_msg "mysql-client-8.0 already installed"
fi

execute_query "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${DB__PASS}';"
execute_query "ALTER USER 'root'@'localhost' IDENTIFIED WITH auth_socket;"

#sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | sudo mysql_secure_installation
#      # current root password (emtpy after installation)
#      # current root password (emtpy after installation)
#    y # Set root password?
#    ${DB__PASS} # new root password
#    ${DB__PASS} # new root password
#    y # Remove anonymous users?
#    y # Disallow root login remotely?
#    y # Remove test database and access to it?
#    y # Reload privilege tables now?
#EOF