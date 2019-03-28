#!/usr/bin/env bash

log_begin_msg "Fixing locale"
sudo chmod 777 /etc/default/locale
echo 'LANGUAGE=en_US.UTF-8' > /etc/default/locale
echo 'LC_ALL=en_US.UTF-8' >> /etc/default/locale
echo 'LANG=en_US.UTF-8' >> /etc/default/locale
echo 'LC_TYPE=en_US.UTF-8' >> /etc/default/locale

sudo chmod 777 /etc/environment
echo 'LC_ALL=en_US.UTF-8' >> /etc/environment
echo 'LANG=en_US.UTF-8' >> /etc/environment

sudo locale-gen en_US.UTF-8 > /dev/null 2>&1
sudo dpkg-reconfigure locales > /dev/null 2>&1
log_end_msg 0