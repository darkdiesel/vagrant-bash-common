#!/usr/bin/env bash

APT_PREFERENCES_ONDREJ="/etc/apt/preferences.d/ondrejphp"

log_action_msg "Installing additional required packages"
source ${VAGRANT__OS_SCRIPTS_PATH}/software-properties-common.sh

log_action_msg "Add ondrej/php repositiry"
sudo add-apt-repository -y ppa:ondrej/php > /dev/null 2>&1

sudo sed -i -e 's/mantic/jammy/g' /etc/apt/sources.list.d/ondrej-ubuntu-php-mantic.sources 

sudo apt update > /dev/null 2>&1

sudo echo "Package: libgd3" >> $APT_PREFERENCES_ONDREJ
sudo echo "Pin: release n=mantic" >> $APT_PREFERENCES_ONDREJ
sudo echo "Pin-Priority: 900" >> $APT_PREFERENCES_ONDREJ


sudo wget http://ftp.osuosl.org/pub/ubuntu/pool/main/i/icu/libicu70_70.1-2_amd64.deb > /dev/null 2>&1
sudo dpkg -i libicu70_70.1-2_amd64.deb > /dev/null 2>&1
sudo rm libicu70_70.1-2_amd64.deb > /dev/null 2>&1

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
