#!/usr/bin/env bash

log_begin_msg "Installing PHP"
sudo apt-get install -y curl php5-cli php5-intl php5-curl php5-xdebug php5-mcrypt php5-gd php-gettext php-pear libapache2-mod-php5 php5-mysqlnd > /dev/null 2>&1
log_end_msg 0


log_action_msg "Copping php5 configs"
sudo cp -R ${VAGRANT__OS_CONFIGS_PATH}/etc/php5/* /etc/php5/ > /dev/null 2>&1


if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
log_begin_msg "Restarting apache2"
    sudo service apache2 restart > /dev/null 2>&1
log_end_msg 0
fi