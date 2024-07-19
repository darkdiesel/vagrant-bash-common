#!/usr/bin/env bash

source ${VAGRANT__OS_SCRIPTS_PATH}/golang-go.sh

#wget https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64
#sudo cp MailHog_linux_amd64 /usr/local/bin/mailhog

#wget https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64
#sudo cp mhsendmail_linux_amd64 /usr/local/bin/mhsendmail

log_begin_msg "Installing Mailhog and mhsendmail"
go get github.com/mailhog/MailHog
go get github.com/mailhog/mhsendmail
log_end_msg 0

log_begin_msg "Create mail links"
if [ ! -f "/usr/local/bin/mhsendmail" ]; then
    sudo ln  ~/gocode/bin/mhsendmail /usr/local/bin/mhsendmail > /dev/null 2>&1
fi

if [ ! -f "/usr/local/bin/sendmail" ]; then
    sudo ln  ~/gocode/bin/mhsendmail /usr/local/bin/sendmail > /dev/null 2>&1
fi

if [ ! -f "/usr/local/bin/mail" ]; then
    sudo ln  ~/gocode/bin/mhsendmail /usr/local/bin/mail > /dev/null 2>&1
fi

if [ ! -f "/usr/local/bin/mailhog" ]; then
    sudo ln  ~/gocode/bin/MailHog /usr/local/bin/mailhog > /dev/null 2>&1
fi
log_end_msg 0

if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
    log_begin_msg "Enable mailhog apache2 host"

    sudo cp /etc/apache2/sites-available/mailhog-default.conf /etc/apache2/sites-available/mailhog.${VAGRANT__HOSTNAME}.conf
    sudo sed -i "s,{SITE_DOMAIN},${VAGRANT__HOSTNAME},g" /etc/apache2/sites-available/mailhog.${VAGRANT__HOSTNAME}.conf

    sudo a2ensite mailhog.${VAGRANT__HOSTNAME}.conf > /dev/null 2>&1
    sudo service apache2 restart > /dev/null 2>&1

    log_end_msg 0
fi


if [ $(dpkg-query -W -f='${Status}' nginx 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
    log_begin_msg "Enable mailhog nginx host"

    sudo cp /etc/nginx/sites-available/mailhog-default.conf /etc/nginx/sites-available/mailhog.${VAGRANT__HOSTNAME}.conf
    sudo sed -i "s,{SITE_DOMAIN},${VAGRANT__HOSTNAME},g" /etc/nginx/sites-available/mailhog.${VAGRANT__HOSTNAME}.conf

    sudo ln -s /etc/nginx/sites-available/mailhog.${VAGRANT__HOSTNAME}.conf /etc/nginx/sites-enabled/ > /dev/null 2>&1
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


MAILHOG_MOD="mailhog.ini"
MAILHOG_PHP_MOD_PATH="/etc/php/"${PACKAGES__PHP__VERSION}"/mods-available/"${MAILHOG_MOD}
VAGRANT_MAILHOG_CONFIG=${VAGRANT__OS_CONFIGS_PATH}"/etc/php/"${PACKAGES__PHP__VERSION}"/mods-available/"${MAILHOG_MOD}

log_begin_msg "Make php use mailhog to send mail"

log_action_msg "Remove old config"

if [ -f $MAILHOG_PHP_MOD_PATH ]; then
    sudo rm -rf $MAILHOG_PHP_MOD_PATH
fi

if [ -f $VAGRANT_MAILHOG_CONFIG ]; then
    sudo cp -R $VAGRANT_MAILHOG_CONFIG $MAILHOG_PHP_MOD_PATH > /dev/null 2>&1
else
  sudo touch $MAILHOG_PHP_MOD_PATH
  sudo chmod 777 $MAILHOG_PHP_MOD_PATH
  sudo echo "sendmail_path = /usr/local/bin/mhsendmail" >> $MAILHOG_PHP_MOD_PATH
  sudo chmod 644 $MAILHOG_PHP_MOD_PATH
fi

log_end_msg 0

log_begin_msg "Enable mailhog mod for php"
sudo phpenmod mailhog
log_end_msg 0

#log_begin_msg "Starting mailhog"
#$(which mailhog) -api-bind-addr="127.0.0.1:8025" -ui-bind-addr="127.0.0.1:8025" -smtp-bind-addr="127.0.0.1:1025" > /dev/null 2>&1
#log_end_msg 0