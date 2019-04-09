#!/usr/bin/env bash

. /lib/lsb/init-functions

source ${VAGRANT__OS_SCRIPTS_PATH}/golang-go.sh

#wget https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64
#sudo cp MailHog_linux_amd64 /usr/local/bin/mailhog

#wget https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64
#sudo cp mhsendmail_linux_amd64 /usr/local/bin/mhsendmail

log_begin_msg "Installing Mailhog and mhsendmail"
go get github.com/mailhog/MailHog
go get github.com/mailhog/mhsendmail
log_end_msg 0

log_begin_msg "Create links"
sudo ln  ~/gocode/bin/mhsendmail /usr/local/bin/mhsendmail
sudo ln  ~/gocode/bin/mhsendmail /usr/local/bin/sendmail
sudo ln  ~/gocode/bin/mhsendmail /usr/local/bin/mail

sudo ln  ~/gocode/bin/MailHog /usr/local/bin/mailhog
log_end_msg 0

if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
    log_begin_msg "Enable mailhog apache2 host"

    sudo cp /etc/apache2/sites-available/mailhog-default.conf /etc/apache2/sites-available/mailhog.${SITES__BASE_DOMAIN}.conf
    sudo sed -i "s,{SITE_DOMAIN},${SITES__BASE_DOMAIN},g" /etc/apache2/sites-available/mailhog.${SITES__BASE_DOMAIN}.conf

    sudo a2ensite mailhog.${SITES__BASE_DOMAIN}.conf > /dev/null 2>&1
    sudo service apache2 restart > /dev/null 2>&1

    log_end_msg 0
fi


if [ $(dpkg-query -W -f='${Status}' nginx 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
    log_begin_msg "Enable mailhog nginx host"

    sudo cp /etc/nginx/sites-available/mailhog-default.conf /etc/nginx/sites-available/mailhog.${SITES__BASE_DOMAIN}.conf
    sudo sed -i "s,{SITE_DOMAIN},${SITES__BASE_DOMAIN},g" /etc/nginx/sites-available/mailhog.${SITES__BASE_DOMAIN}.conf

    sudo ln -s /etc/nginx/sites-available/mailhog.${SITES__BASE_DOMAIN}.conf /etc/nginx/sites-enabled/ > /dev/null 2>&1
    sudo service nginx restart > /dev/null 2>&1

    log_end_msg 0
fi

log_begin_msg "Make mailhog start on boot like a service"
sudo cp -R ${VAGRANT__OS_CONFIGS_PATH}/etc/systemd/system/mailhog.service /etc/systemd/system/mailhog.service

sudo systemctl start mailhog > /dev/null 2>&1
sudo systemctl enable mailhog > /dev/null 2>&1
log_end_msg 0


#log_begin_msg "Make mailhog start on boot"
#sudo chmod 777 /etc/crontab > /dev/null 2>&1
#echo "@reboot root $(which mailhog) -api-bind-addr='127.0.0.1:8025' -ui-bind-addr='127.0.0.1:8025' -smtp-bind-addr='127.0.0.1:1025'" >> /etc/crontab
#sudo chmod 644 /etc/crontab > /dev/null 2>&1
#sudo update-rc.d cron defaults > /dev/null
#log_end_msg 0

log_begin_msg "Make php use mailhog to send mail"
if [ -f "/etc/php/7.2/mods-available/mailhog.ini" ]; then
    sudo rm /etc/php/7.2/mods-available/mailhog.ini > /dev/null
fi

sudo touch /etc/php/7.2/mods-available/mailhog.ini
sudo chmod 777 /etc/php/7.2/mods-available/mailhog.ini
sudo echo "sendmail_path = /usr/local/bin/mhsendmail" >> /etc/php/7.2/mods-available/mailhog.ini
sudo chmod 644 /etc/php/7.2/mods-available/mailhog.ini
log_end_msg 0

log_begin_msg "Enable mailhog mod for php"
sudo phpenmod mailhog
log_end_msg 0

#log_begin_msg "Starting mailhog"
#$(which mailhog) -api-bind-addr="127.0.0.1:8025" -ui-bind-addr="127.0.0.1:8025" -smtp-bind-addr="127.0.0.1:2025" > /dev/null 2>&1
#log_end_msg 0