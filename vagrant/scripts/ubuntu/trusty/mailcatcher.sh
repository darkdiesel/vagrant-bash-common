#!/usr/bin/env bash

source ${VAGRANT_SCRIPTS}/build-essential.sh
source ${VAGRANT_SCRIPTS}/ruby-dev.sh
source ${VAGRANT_SCRIPTS}/sqlite3.sh
source ${VAGRANT_SCRIPTS}/libsqlite3-dev.sh

log_begin_msg "Installing mailcatcher and gems for ruby"

sudo gem install bundler > /dev/null 2>&1
sudo gem install eventmachine -v 1.0.3 > /dev/null 2>&1
sudo gem install mime-types -v 2.99.1 > /dev/null 2>&1
sudo gem install mailcatcher -v 0.5.12 > /dev/null 2>&1

log_end_msg 0

if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
    log_begin_msg "Enable mailcatcher apache2 host"

    sudo cp /etc/apache2/sites-available/mailcatcher-default.conf /etc/apache2/sites-available/mailcatcher.${MAIN_SITE_DOMAIN}.conf
    sudo sed -i "s,{SITE_DOMAIN},${MAIN_SITE_DOMAIN},g" /etc/apache2/sites-available/mailcatcher.${MAIN_SITE_DOMAIN}.conf
    sudo sed -i "s,{SITE_DIR},${MAIN_SITE_DIR},g" /etc/apache2/sites-available/mailcatcher.${MAIN_SITE_DOMAIN}.conf

    sudo a2ensite mailcatcher.${MAIN_SITE_DOMAIN}.conf > /dev/null 2>&1
    sudo service apache2 restart > /dev/null 2>&1

    log_end_msg 0
fi


if [ $(dpkg-query -W -f='${Status}' nginx 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
    log_begin_msg "Enable mailcatcher nginx host"

    sudo cp /etc/nginx/sites-available/mailcatcher-default.conf /etc/nginx/sites-available/mailcatcher.${MAIN_SITE_DOMAIN}.conf
    sudo sed -i "s,{SITE_DOMAIN},${MAIN_SITE_DOMAIN},g" /etc/nginx/sites-available/mailcatcher.${MAIN_SITE_DOMAIN}.conf
    sudo sed -i "s,{SITE_DIR},${MAIN_SITE_DIR},g" /etc/nginx/sites-available/mailcatcher.${MAIN_SITE_DOMAIN}.conf

    sudo ln -s /etc/nginx/sites-available/mailcatcher.${MAIN_SITE_DOMAIN}.conf /etc/nginx/sites-enabled/ > /dev/null 2>&1
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
sudo touch /etc/php5/mods-available/mailcatcher.ini
sudo chmod 777 /etc/php5/mods-available/mailcatcher.ini
sudo echo "sendmail_path = /usr/bin/env $(which catchmail) -f 'mailcatcher@${MAIN_SITE_DOMAIN}'" >> /etc/php5/mods-available/mailcatcher.ini
sudo chmod 644 /etc/php5/mods-available/mailcatcher.ini

# xenial
#sudo touch /etc/php/7.0/mods-available/mailcatcher.ini
#sudo chmod 777 /etc/php/7.0/mods-available/mailcatcher.ini
#sudo echo "sendmail_path = /usr/bin/env $(which catchmail) -f 'mailcatcher@${MAIN_SITE_DOMAIN}'" >> /etc/php/7.0/mods-available/mailcatcher.ini
#sudo chmod 644 /etc/php/7.0/mods-available/mailcatcher.ini
log_end_msg 0

log_begin_msg "Notify php mod manager (5.5+)"

# older ubuntus
sudo php5enmod mailcatcher
sudo service apache2 restart > /dev/null 2>&1

# xenial
#sudo phpenmod mailcatcher
log_end_msg 0

log_begin_msg "Starting mailcatcher"
$(which mailcatcher) --http-ip=0.0.0.0
log_end_msg 0