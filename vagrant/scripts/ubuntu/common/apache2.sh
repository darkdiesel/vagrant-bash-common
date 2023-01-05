#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing apache2"
    sudo apt-get install -y apache2 > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        sudo service apache2 stop
        log_end_msg 0
    fi
else
    log_begin_msg "apache2 installed"
    log_end_msg 0
fi

log_action_msg "Removing apache2 default hosts"
    sudo a2dissite 000-default.conf > /dev/null 2>&1
#    sudo rm -rf /etc/apache2/sites-enabled/* > /dev/null 2>&1


log_action_msg "Backup apache2 config"
if [ ! -f "/etc/apache2/ports.conf.bak" ]; then
    sudo cp /etc/apache2/ports.conf /etc/apache2/ports.conf.bak > /dev/null
fi


log_action_msg "Copying apache2 configs"
sudo cp -R ${VAGRANT__UBUNTU_COMMON_CONFIGS_PATH}/etc/apache2/* /etc/apache2/ > /dev/null 2>&1


log_action_msg "Creating links for apache2 hosts"
for i in `seq 1 ${SITES__COUNT}`;
do
    eval VAGRANT_SITE_DOMAIN='$'SITES__SITE_"$i"__DOMAIN
    eval VAGRANT_SITE_DIR='$'SITES__SITE_"$i"__DIR
    eval VAGRANT_SITE_PATH='$'SITES__SITE_"$i"__PATH

    if [ -d "$VAGRANT_SITE_PATH" ]; then
        sudo cp /etc/apache2/sites-available/vagrant-site-default.conf /etc/apache2/sites-available/${VAGRANT_SITE_DOMAIN}.conf
        sudo sed -i "s,{SITE_DOMAIN},${VAGRANT_SITE_DOMAIN},g" /etc/apache2/sites-available/${VAGRANT_SITE_DOMAIN}.conf
        sudo sed -i "s,{SITE_PATH},${VAGRANT_SITE_PATH},g" /etc/apache2/sites-available/${VAGRANT_SITE_DOMAIN}.conf
        sudo a2ensite ${VAGRANT_SITE_DOMAIN}.conf > /dev/null 2>&1

        log_action_msg "Add apache2 host for ${VAGRANT_SITE_DOMAIN}"
    fi
done


log_begin_msg "Enable apache mods"
sudo a2enmod rewrite > /dev/null 2>&1
sudo a2enmod expires > /dev/null 2>&1
sudo a2enmod headers > /dev/null 2>&1

#sudo a2enmod ssl > /dev/null 2>&1

sudo a2enmod proxy_fcgi > /dev/null 2>&1
sudo a2enmod proxy > /dev/null 2>&1
sudo a2enmod actions > /dev/null 2>&1
sudo a2enmod alias > /dev/null 2>&1
#sudo a2enmod proxy_http > /dev/null 2>&1
#sudo a2enmod proxy_ajp > /dev/null 2>&1
#sudo a2enmod proxy_balancer > /dev/null 2>&1
#sudo a2enmod proxy_connect > /dev/null 2>&1
#sudo a2enmod proxy_html > /dev/null 2>&1
log_end_msg 0

log_begin_msg "Installing libapache2-mod-rpaf"
sudo apt-get install -y libapache2-mod-rpaf > /dev/null 2>&1

if [[ $? > 0 ]]; then
    log_end_msg 1
else
    log_end_msg 0
fi

log_begin_msg "Update privileges for apache2 logs"
sudo chmod 777 -R /var/log/apache2/ > /dev/null 2>&1
log_end_msg 0

log_begin_msg "Starting apache2"
    sudo service apache2 start > /dev/null 2>&1
log_end_msg 0
