#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' php-fpm 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing php8.3-fpm and packages"
    sudo apt-get install -y php8.3-fpm php8.3-cli php8.3-common php8.3-opcache php8.3-readline php8.3-phpdbg php8.3-mbstring php8.3-gd php8.3-curl php8.3-cgi php8.3-intl php8.3-soap php8.3-xml php8.3-xmlrpc php8.3-mysql php8.3-zip  php8.3-ssh2 php8.3-xdebug > /dev/null 2>&1

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
    sudo apt-get install -y php-mysql php8.3-mysql > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_begin_msg "php-mysql installed"
    log_end_msg 0
fi

#sudo apt install php8.3-sqlite3

log_action_msg "Starting php8.3-fpm"
sudo service php8.3-fpm start  > /dev/null 2>&1

log_action_msg "Enabling php8.3-fpm"
sudo systemctl enable php8.3-fpm > /dev/null 2>&1

log_action_msg "Enabling apache2 php8.3-fpm conf"
sudo a2enconf php8.3-fpm > /dev/null 2>&1

log_action_msg "Copping php8.3 configs"
sudo cp -R ${VAGRANT__UBUNTU_COMMON_CONFIGS_PATH}/etc/php/8.3/* /etc/php/8.3/ > /dev/null 2>&1


if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
log_begin_msg "Restarting apache2"
    sudo service apache2 restart > /dev/null 2>&1
log_end_msg 0
fi
