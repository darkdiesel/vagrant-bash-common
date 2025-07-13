#!/usr/bin/env bash

PHPMYADMIN_DIR=$(sudo -H -u vagrant bash -c 'realpath $HOME/phpmyadmin')

if [ ! -d "$PHPMYADMIN_DIR" ]; then
    log_begin_msg "Installing phpmyadmin"
    #sudo wget -P /var/www/ https://www.phpmyadmin.net/packages.json > /dev/null 2>&1
    composer create-project phpmyadmin/phpmyadmin --repository-url=https://www.phpmyadmin.net/packages.json --no-dev $PHPMYADMIN_DIR > /dev/null 2>&1
    sudo cp $PHPMYADMIN_DIR/config.sample.inc.php $PHPMYADMIN_DIR/config.inc.php > /dev/null 2>&1
    #sudo rm /var/www/packages.json
    
    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_action_msg "phpmyadmin already installed"
fi

if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
    log_begin_msg "Enable pma apache2 host"

    sudo cp /etc/apache2/sites-available/vagrant-site-default.conf /etc/apache2/sites-available/pma.${VAGRANT__HOSTNAME}.conf

    sudo sed -i "s,{SITE_DOMAIN},pma.${VAGRANT__HOSTNAME},g" /etc/apache2/sites-available/pma.${VAGRANT__HOSTNAME}.conf
    sudo sed -i "s,{SITE_PATH},${PHPMYADMIN_DIR},g" /etc/apache2/sites-available/pma.${VAGRANT__HOSTNAME}.conf
    
    # sudo cp /etc/apache2/sites-available/pma-default.conf /etc/apache2/sites-available/pma.${VAGRANT__HOSTNAME}.conf
    # sudo sed -i "s,{SITE_DOMAIN},${VAGRANT__HOSTNAME},g" /etc/apache2/sites-available/pma.${VAGRANT__HOSTNAME}.conf

    sudo a2ensite pma.${VAGRANT__HOSTNAME}.conf > /dev/null 2>&1
    sudo service apache2 restart > /dev/null 2>&1

    log_end_msg 0
fi

if [ $(dpkg-query -W -f='${Status}' nginx 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
    log_begin_msg "Enable pma nginx host"

    sudo cp /etc/nginx/sites-available/vagrant-site-default.conf /etc/nginx/sites-available/pma.${VAGRANT__HOSTNAME}.conf

    sudo sed -i "s,{SITE_DOMAIN},pma.${VAGRANT__HOSTNAME},g" /etc/nginx/sites-available/pma.${VAGRANT__HOSTNAME}.conf
    sudo sed -i "s,{SITE_PATH},${PHPMYADMIN_DIR},g" /etc/nginx/sites-available/pma.${VAGRANT__HOSTNAME}.conf

    # sudo cp /etc/nginx/sites-available/pma-default.conf /etc/nginx/sites-available/pma.${VAGRANT__HOSTNAME}.conf
    # sudo sed -i "s,{SITE_DOMAIN},${VAGRANT__HOSTNAME},g" /etc/nginx/sites-available/pma.${VAGRANT__HOSTNAME}.conf

    sudo ln -s /etc/nginx/sites-available/pma.${VAGRANT__HOSTNAME}.conf /etc/nginx/sites-enabled/ > /dev/null 2>&1
    sudo service nginx restart > /dev/null 2>&1

    log_end_msg 0
fi
