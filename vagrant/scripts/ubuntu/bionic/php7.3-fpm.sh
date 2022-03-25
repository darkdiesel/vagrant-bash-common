#!/usr/bin/env bash

. /lib/lsb/init-functions


sudo add-apt-repository ppa:ondrej/php > /dev/null 2>&1
sudo apt update > /dev/null 2>&1


if [ $(dpkg-query -W -f='${Status}' php-fpm 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing php7.3-fpm and packages"
    sudo apt-get install -y php7.3-fpm php7.3-mbstring php7.3-gd php7.3-curl php7.3-cgi php7.3-intl php7.3-xml php7.3-mysql php7.3-zip php7.3-xdebug > /dev/null 2>&1
    #TODO add installation for php7.2-mcrypt

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

log_action_msg "Starting php7.3-fpm"
sudo service php7.3-fpm start  > /dev/null 2>&1

log_action_msg "Enabling php7.3-fpm"
sudo systemctl enable php7.3-fpm > /dev/null 2>&1

log_action_msg "Enabling apache2 php7.3-fpm conf"
sudo a2enconf php7.3-fpm > /dev/null 2>&1

log_action_msg "Copping php7.3 configs"
sudo cp -R ${VAGRANT__UBUNTU_COMMON_CONFIGS_PATH}/etc/php/7.3/* /etc/php/7.3/ > /dev/null 2>&1


if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
log_begin_msg "Restarting apache2"
    sudo service apache2 restart > /dev/null 2>&1
log_end_msg 0
fi
