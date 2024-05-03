r#!/usr/bin/env bash

source ${VAGRANT__OS_SCRIPTS_PATH}/build-essential.sh
source ${VAGRANT__OS_SCRIPTS_PATH}/software-properties-common.sh
source ${VAGRANT__OS_SCRIPTS_PATH}/ruby-dev.sh
source ${VAGRANT__OS_SCRIPTS_PATH}/sqlite3.sh
source ${VAGRANT__OS_SCRIPTS_PATH}/libsqlite3-dev.sh

log_begin_msg "Installing mailcatcher and gems for ruby"

sudo gem install bundler > /dev/null 2>&1
sudo gem install sqlite3 -v 1.6.9 > /dev/null 2>&1
sudo gem install net-imap -v 0.3.7 > /dev/null 2>&1
sudo gem install mailcatcher -v 0.9.0 > /dev/null 2>&1

log_end_msg 0

if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
    log_begin_msg "Enable mailcatcher apache2 host"

    sudo cp /etc/apache2/sites-available/mailcatcher-default.conf /etc/apache2/sites-available/mailcatcher.${SITES__BASE_DOMAIN}.conf
    sudo sed -i "s,{SITE_DOMAIN},${SITES__BASE_DOMAIN},g" /etc/apache2/sites-available/mailcatcher.${SITES__BASE_DOMAIN}.conf

    sudo a2ensite mailcatcher.${SITES__BASE_DOMAIN}.conf > /dev/null 2>&1
    sudo service apache2 restart > /dev/null 2>&1

    log_end_msg 0
fi


if [ $(dpkg-query -W -f='${Status}' nginx 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
    log_begin_msg "Enable mailcatcher nginx host"

    sudo cp /etc/nginx/sites-available/mailcatcher-default.conf /etc/nginx/sites-available/mailcatcher.${SITES__BASE_DOMAIN}.conf
    sudo sed -i "s,{SITE_DOMAIN},${SITES__BASE_DOMAIN},g" /etc/nginx/sites-available/mailcatcher.${SITES__BASE_DOMAIN}.conf

    sudo ln -s /etc/nginx/sites-available/mailcatcher.${SITES__BASE_DOMAIN}.conf /etc/nginx/sites-enabled/ > /dev/null 2>&1
    sudo service nginx restart > /dev/null 2>&1

    log_end_msg 0
fi

log_begin_msg "Make mailcatcher start on boot"

sudo chmod 777 /etc/crontab > /dev/null 2>&1
echo "@reboot root $(which mailcatcher) --http-ip=0.0.0.0" >> /etc/crontab
sudo chmod 644 /etc/crontab > /dev/null 2>&1
sudo update-rc.d cron defaults > /dev/null

log_end_msg 0

log_begin_msg "Make php use mailcatcher to send mail"

# older ubuntus
#sudo touch /etc/php5/mods-available/mailcatcher.ini
#sudo chmod 777 /etc/php5/mods-available/mailcatcher.ini
#sudo echo "sendmail_path = /usr/bin/env $(which catchmail) -f 'mailcatcher@${SITES__BASE_DOMAIN}'" >> /etc/php5/mods-available/mailcatcher.ini
#sudo chmod 644 /etc/php5/mods-available/mailcatcher.ini

MAILCATCHER_MOD="mailcatcher.ini"
MAILCATCHER_PHP_MOD_PATH="/etc/php/"${PACKAGES__PHP__VERSION}"/mods-available/"${MAILCATCHER_MOD}
VAGRANT_MAILCATCHER_CONFIG=${VAGRANT__OS_CONFIGS_PATH}"/etc/php/"${PACKAGES__PHP__VERSION}"/mods-available/"${MAILCATCHER_MOD}

# xenial
sudo touch MAILCATCHER_PHP_MOD_PATH
sudo chmod 777 MAILCATCHER_PHP_MOD_PATH
sudo echo "sendmail_path = /usr/bin/env $(which catchmail) -f 'mailcatcher@${SITES__BASE_DOMAIN}'" >> MAILCATCHER_PHP_MOD_PATH
sudo chmod 644 MAILCATCHER_PHP_MOD_PATH
log_end_msg 0

# older ubuntus
#log_begin_msg "Notify php mod manager (5.5+)"
#sudo php5enmod mailcatcher
#sudo service apache2 restart > /dev/null 2>&1
#log_end_msg 0

# xenial
log_begin_msg "Enable mailcatcher mod for php"
sudo phpenmod mailcatcher
log_end_msg 0

log_begin_msg "Starting mailcatcher"
$(which mailcatcher) --http-ip=0.0.0.0
log_end_msg 0