#!/usr/bin/env bash

if [ ! -d "/usr/share/phpmyadmin/" ]; then
    log_begin_msg "Installing PhpMyAdmin"
    composer create-project phpmyadmin/phpmyadmin --repository-url=https://www.phpmyadmin.net/packages.json --no-dev /usr/share/phpmyadmin/ > /dev/null 2>&1
    
    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
    
    log_end_msg 0
else
    log_action_msg "PhpMyAdmin already installed"
fi

#log_begin_msg "Installing PhpMyAdmin"
#sudo wget -P /var/www/ https://www.phpmyadmin.net/packages.json > /dev/null 2>&1
#sudo composer create-project phpmyadmin/phpmyadmin --repository-url=/var/www/packages.json --no-dev /var/www/pma > /dev/null 2>&1
#sudo cp /vagrant/var/www/pma/config.inc.php /var/www/pma/config.inc.php > /dev/null 2>&1
#sudo rm /var/www/packages.json
#log_end_msg 0

if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
    log_begin_msg "Enable pma apache2 host"

    sudo cp /etc/apache2/sites-available/pma-default.conf /etc/apache2/sites-available/pma.${VAGRANT__HOSTNAME}.conf
    sudo sed -i "s,{SITE_DOMAIN},${VAGRANT__HOSTNAME},g" /etc/apache2/sites-available/pma.${VAGRANT__HOSTNAME}.conf

    sudo a2ensite pma.${VAGRANT__HOSTNAME}.conf > /dev/null 2>&1
    sudo service apache2 restart > /dev/null 2>&1

    log_end_msg 0
fi

if [ $(dpkg-query -W -f='${Status}' nginx 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
    log_begin_msg "Enable pma nginx host"

    sudo cp /etc/nginx/sites-available/pma-default.conf /etc/nginx/sites-available/pma.${VAGRANT__HOSTNAME}.conf
    sudo sed -i "s,{SITE_DOMAIN},${VAGRANT__HOSTNAME},g" /etc/nginx/sites-available/pma.${VAGRANT__HOSTNAME}.conf

    sudo ln -s /etc/nginx/sites-available/pma.${VAGRANT__HOSTNAME}.conf /etc/nginx/sites-enabled/ > /dev/null 2>&1
    sudo service nginx restart > /dev/null 2>&1

    log_end_msg 0
fi
