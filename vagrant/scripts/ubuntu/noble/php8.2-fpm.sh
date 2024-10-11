#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' php-fpm 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing php8.2-fpm and packages"
    sudo apt-get install -y php8.2-fpm php8.2-mbstring php8.2-gd php8.2-curl php8.2-cgi php8.2-intl php8.2-xml php8.2-mysql php8.2-zip php8.2-xdebug > /dev/null 2>&1
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

log_action_msg "Starting php8.2-fpm"
sudo service php8.2-fpm start  > /dev/null 2>&1

log_action_msg "Enabling php8.2-fpm"
sudo systemctl enable php8.2-fpm > /dev/null 2>&1

log_action_msg "Enabling apache2 php8.2-fpm conf"
sudo a2enconf php8.2-fpm > /dev/null 2>&1

log_action_msg "Copping php8.2 configs"
sudo cp -R ${VAGRANT__UBUNTU_COMMON_CONFIGS_PATH}/etc/php/8.1/* /etc/php/8.1/ > /dev/null 2>&1


if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
log_begin_msg "Restarting apache2"
    sudo service apache2 restart > /dev/null 2>&1
log_end_msg 0
fi
