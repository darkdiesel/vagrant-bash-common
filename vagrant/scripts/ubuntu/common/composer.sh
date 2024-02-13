#!/usr/bin/env bash

log_begin_msg "Installing composer"
sudo curl -sS https://getcomposer.org/installer | php > /dev/null 2>&1
sudo mv composer.phar /usr/local/bin/composer > /dev/null 2>&1

#curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin/ --filename=composer > /dev/null 2>&1

#if [ ! -d "/root/.composer" ]; then
#  sudo mkdir /root/.composer > /dev/null
#fi

#sudo cp /vagrant/composer/auth.json /root/.composer/auth.json > /dev/null 2>&1
log_end_msg 0

log_begin_msg "Setup swap for correct packages installation"
# see for more info https://getcomposer.org/doc/articles/troubleshooting.md#proc-open-fork-failed-errors
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024 > /dev/null 2>&1
sudo /sbin/mkswap /var/swap.1 > /dev/null 2>&1
sudo /sbin/swapon /var/swap.1 > /dev/null 2>&1
log_end_msg 0