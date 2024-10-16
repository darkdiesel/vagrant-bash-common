#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' php-fpm 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing php8.4-fpm and packages"
    sudo apt-get install -y php8.4-fpm php8.4-cli php8.4-common php8.4-opcache php8.4-readline php8.4-phpdbg php8.4-mbstring php8.4-gd php8.4-curl php8.4-cgi php8.4-intl php8.4-soap php8.4-xml php8.4-xmlrpc php8.4-mysql php8.4-zip  php8.4-ssh2 php8.4-xdebug > /dev/null 2>&1

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
    sudo apt-get install -y php-mysql php8.4-mysql > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_begin_msg "php-mysql installed"
    log_end_msg 0
fi

#sudo apt install php8.4-sqlite3

log_action_msg "Starting php8.4-fpm"
sudo service php8.4-fpm start  > /dev/null 2>&1

log_action_msg "Enabling php8.4-fpm"
sudo systemctl enable php8.4-fpm > /dev/null 2>&1

log_action_msg "Enabling apache2 php8.4-fpm conf"
sudo a2enconf php8.4-fpm > /dev/null 2>&1

log_action_msg "Copping php8.4 configs"
sudo cp -R ${VAGRANT__UBUNTU_COMMON_CONFIGS_PATH}/etc/php/8.3/* /etc/php/8.3/ > /dev/null 2>&1


if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
log_begin_msg "Restarting apache2"
    sudo service apache2 restart > /dev/null 2>&1
log_end_msg 0
fi
