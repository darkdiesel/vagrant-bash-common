#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' php-fpm 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing php8.1-fpm and packages"
    sudo apt-get install -y php8.1-fpm php8.1-mbstring php8.1-gd php8.1-curl php8.1-cgi php8.1-intl php8.1-xml php8.1-mysql php8.1-zip php8.1-xdebug > /dev/null 2>&1
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

log_action_msg "Starting php8.1-fpm"
sudo service php8.1-fpm start  > /dev/null 2>&1

log_action_msg "Enabling php8.1-fpm"
sudo systemctl enable php8.1-fpm > /dev/null 2>&1

log_action_msg "Enabling apache2 php8.1-fpm conf"
sudo a2enconf php8.1-fpm > /dev/null 2>&1

log_action_msg "Copping php8.1 configs"
sudo cp -R ${VAGRANT__UBUNTU_COMMON_CONFIGS_PATH}/etc/php/8.1/* /etc/php/8.1/ > /dev/null 2>&1


if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
log_begin_msg "Restarting apache2"
    sudo service apache2 restart > /dev/null 2>&1
log_end_msg 0
fi
