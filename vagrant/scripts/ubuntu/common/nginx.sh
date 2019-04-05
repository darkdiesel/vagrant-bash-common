#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' nginx 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing nginx"
    sudo apt-get install nginx -y > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        sudo service nginx stop
        log_end_msg 0
    fi
else
    log_begin_msg "nginx installed"
    log_end_msg 0
fi

log_begin_msg "Generate ssl certs for nginx"
if [ ! -d /etc/nginx/ssl ]; then
    sudo mkdir /etc/nginx/ssl
fi

if [ -d "$MAIN_SITE_PATH" ]; then
    if [ ! -d ${VAGRANT_UBUNTU_COMMON_CONFIGS_PATH}"/etc/nginx/ssl" ]; then
        sudo mkdir ${VAGRANT_UBUNTU_COMMON_CONFIGS_PATH}/etc/nginx/ssl
    fi

    if [ ! -f "${VAGRANT_UBUNTU_COMMON_CONFIGS_PATH}/etc/nginx/ssl/${MAIN_SITE_DOMAIN}_bundle.crt" ]; then
        if [ ! -f "${VAGRANT_UBUNTU_COMMON_CONFIGS_PATH}/etc/nginx/ssl/${MAIN_SITE_DOMAIN}_private.key" ]; then
            sudo openssl req -new -newkey rsa:1024 -nodes -keyout ${VAGRANT_UBUNTU_COMMON_CONFIGS_PATH}/etc/nginx/ssl/${MAIN_SITE_DOMAIN}_private.key -x509 -days 500 -subj /C=RU/ST=Grodno/L=Grodno/O=Companyname/OU=User/CN=${MAIN_SITE_DOMAIN}/emailAddress=admin@${MAIN_SITE_DOMAIN} -out ${VAGRANT_UBUNTU_COMMON_CONFIGS_PATH}/etc/nginx/ssl/${MAIN_SITE_DOMAIN}_bundle.crt > /dev/null 2>&1
        fi
    fi
fi
log_end_msg 0


log_action_msg "Remove nginx default hosts"
sudo rm -rf /etc/nginx/sites-enabled/* > /dev/null 2>&1


log_action_msg "Backup nginx config"
if [ ! -f "/etc/nginx/nginx.conf.bak" ]; then
    sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
fi


log_action_msg "Copy nginx configs"
sudo cp -R ${VAGRANT_UBUNTU_COMMON_CONFIGS_PATH}/etc/nginx/* /etc/nginx/


log_begin_msg "Create links for nginx hosts"
for i in `seq 1 ${SITES_COUNT}`;
do
    eval VAGRANT_SITE_DOMAIN='$'SITES_SITE_"$i"_DOMAIN
    eval VAGRANT_SITE_DIR='$'SITES_SITE_"$i"_DIR
    eval VAGRANT_SITE_PATH='$'SITES_SITE_"$i"_PATH

    if [ -d "$VAGRANT_SITE_PATH" ]; then
        sudo cp /etc/nginx/sites-available/vagrant-site-ssl.conf /etc/nginx/sites-available/${VAGRANT_SITE_DOMAIN}.conf
        sudo sed -i "s,{SITE_DOMAIN},${VAGRANT_SITE_DOMAIN},g" /etc/nginx/sites-available/${VAGRANT_SITE_DOMAIN}.conf
        sudo sed -i "s,{SITE_PATH},${VAGRANT_SITE_PATH},g" /etc/nginx/sites-available/${VAGRANT_SITE_DOMAIN}.conf
        sudo ln -s /etc/nginx/sites-available/${VAGRANT_SITE_DOMAIN}.conf /etc/nginx/sites-enabled/ > /dev/null

        log_action_msg "Add nginx host for ${VAGRANT_SITE_DOMAIN}"
    fi
done

#if [ -d "$MAIN_SITE_PATH" ]; then
#    sudo cp /etc/nginx/sites-available/vagrant-site-ssl.conf /etc/nginx/sites-available/${MAIN_SITE_DOMAIN}.conf
#    sudo sed -i "s,{SITE_DOMAIN},${MAIN_SITE_DOMAIN},g" /etc/nginx/sites-available/${MAIN_SITE_DOMAIN}.conf
#    sudo sed -i "s,{SITE_PATH},${MAIN_SITE_PATH},g" /etc/nginx/sites-available/${MAIN_SITE_DOMAIN}.conf
#    sudo ln -s /etc/nginx/sites-available/${MAIN_SITE_DOMAIN}.conf /etc/nginx/sites-enabled/ > /dev/null
#fi
log_end_msg 0

log_begin_msg "Update privileges for nginx logs"
sudo chmod 777 -R /var/log/nginx/ > /dev/null
log_end_msg 0

log_begin_msg "Starting nginx"
    sudo service nginx start > /dev/null 2>&1
log_end_msg 0
