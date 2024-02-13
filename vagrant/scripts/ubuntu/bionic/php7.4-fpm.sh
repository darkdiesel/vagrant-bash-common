#!/usr/bin/env bash

sudo add-apt-repository ppa:ondrej/php > /dev/null 2>&1
sudo apt update > /dev/null 2>&1

if [ $(dpkg-query -W -f='${Status}' php-fpm 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing php7.4-fpm and packages"
    sudo apt-get install -y php7.4-fpm php7.4-mbstring php7.4-gd php7.4-curl php7.4-cgi php7.4-intl php7.4-xml php7.4-mysql php7.4-zip php7.4-xdebug > /dev/null 2>&1
    #@TODO: add installation for php7.2-mcrypt

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_begin_msg "php-fpm installed"
    log_end_msg 0
fi

if [ $(dpkg-query -W -f='${Status}' php-mysql 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing php-mysql"
    sudo apt-get install -y php-mysql > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_begin_msg "php-mysql installed"
    log_end_msg 0
fi

log_action_msg "Starting php7.4-fpm"
sudo service php7.4-fpm start  > /dev/null 2>&1

log_action_msg "Enabling php7.4-fpm"
sudo systemctl enable php7.4-fpm > /dev/null 2>&1

log_action_msg "Enabling apache2 php7.4-fpm conf"
sudo a2enconf php7.4-fpm > /dev/null 2>&1

log_action_msg "Copping php7.4 configs"
sudo cp -R ${VAGRANT__UBUNTU_COMMON_CONFIGS_PATH}/etc/php/7.4/* /etc/php/7.4/ > /dev/null 2>&1


if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
log_begin_msg "Restarting apache2"
    sudo service apache2 restart > /dev/null 2>&1
log_end_msg 0
fi
