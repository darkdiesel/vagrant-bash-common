#!/usr/bin/env bash

source ${VAGRANT__OS_SCRIPTS_PATH}/curl.sh

source ${VAGRANT__OS_SCRIPTS_PATH}/swap-setup.sh

log_begin_msg "Installing composer"
sudo curl -sS https://getcomposer.org/installer | php > /dev/null 2>&1
sudo mv composer.phar /usr/local/bin/composer > /dev/null 2>&1

#curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin/ --filename=composer > /dev/null 2>&1

#if [ ! -d "/root/.composer" ]; then
#  sudo mkdir /root/.composer > /dev/null
#fi

#sudo cp /vagrant/composer/auth.json /root/.composer/auth.json > /dev/null 2>&1
log_end_msg 0