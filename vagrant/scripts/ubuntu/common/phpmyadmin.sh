#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' phpmyadmin 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing phpmyadmin"

    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-user string $DB__USER"
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DB__PASS"
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DB__PASS"
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DB__PASS"
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"

#    sudo echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
#    sudo echo "phpmyadmin phpmyadmin/app-password-confirm password $DB__PASS" | debconf-set-selections
#    sudo echo "phpmyadmin phpmyadmin/mysql/admin-pass password $DB__PASS" | debconf-set-selections
#    sudo echo "phpmyadmin phpmyadmin/mysql/app-pass password $DB__PASS" | debconf-set-selections
#    sudo echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections

    sudo apt-get install -y phpmyadmin > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_begin_msg "phpmyadmin installed"
    log_end_msg 0
fi

if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
    log_begin_msg "Enable pma apache2 host"

    sudo cp /etc/apache2/sites-available/pma-default.conf /etc/apache2/sites-available/pma.${SITES__BASE_DOMAIN}.conf
    sudo sed -i "s,{SITE_DOMAIN},${SITES__BASE_DOMAIN},g" /etc/apache2/sites-available/pma.${SITES__BASE_DOMAIN}.conf

    sudo a2ensite pma.${SITES__BASE_DOMAIN}.conf > /dev/null 2>&1
    sudo service apache2 restart > /dev/null 2>&1

    log_end_msg 0
fi


if [ $(dpkg-query -W -f='${Status}' nginx 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
    log_begin_msg "Enable pma nginx host"

    sudo cp /etc/nginx/sites-available/pma-default.conf /etc/nginx/sites-available/pma.${SITES__BASE_DOMAIN}.conf
    sudo sed -i "s,{SITE_DOMAIN},${SITES__BASE_DOMAIN},g" /etc/nginx/sites-available/pma.${SITES__BASE_DOMAIN}.conf

    sudo ln -s /etc/nginx/sites-available/pma.${SITES__BASE_DOMAIN}.conf /etc/nginx/sites-enabled/ > /dev/null 2>&1
    sudo service nginx restart > /dev/null 2>&1

    log_end_msg 0
fi
