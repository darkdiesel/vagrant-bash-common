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

log_action_msg "Removing nginx default hosts"
sudo rm -rf /etc/nginx/sites-enabled/* > /dev/null 2>&1

log_action_msg "Backup nginx config"
if [ ! -f "/etc/nginx/nginx.conf.bak" ]; then
    sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
fi

log_action_msg "Copying nginx configs"
sudo cp -R ${VAGRANT__UBUNTU_COMMON_CONFIGS_PATH}/etc/nginx/* /etc/nginx/

log_action_msg "Start creating links for nginx hosts"
for i in `seq 1 ${SITES__COUNT}`;
do
    eval VAGRANT_SITE_DOMAIN='$'SITES__SITE_"$i"__DOMAIN
    eval VAGRANT_SITE_DIR='$'SITES__SITE_"$i"__DIR
    eval VAGRANT_SITE_PATH='$'SITES__SITE_"$i"__PATH

    if [ -d "$VAGRANT_SITE_PATH" ]; then
        sudo cp /etc/nginx/sites-available/vagrant-site-ssl.conf /etc/nginx/sites-available/${VAGRANT_SITE_DOMAIN}.conf
        sudo sed -i "s,{SITE_DOMAIN},${VAGRANT_SITE_DOMAIN},g" /etc/nginx/sites-available/${VAGRANT_SITE_DOMAIN}.conf
        sudo sed -i "s,{SITE_PATH},${VAGRANT_SITE_PATH},g" /etc/nginx/sites-available/${VAGRANT_SITE_DOMAIN}.conf
        sudo ln -s /etc/nginx/sites-available/${VAGRANT_SITE_DOMAIN}.conf /etc/nginx/sites-enabled/ > /dev/null

        log_action_msg "Added nginx host for ${VAGRANT_SITE_DOMAIN}"

        if [ ! -d /etc/nginx/ssl ]; then
            sudo mkdir /etc/nginx/ssl
        fi

        if [ ! -d ${VAGRANT__UBUNTU_COMMON_CONFIGS_PATH}"/etc/nginx/ssl" ]; then
            sudo mkdir ${VAGRANT__UBUNTU_COMMON_CONFIGS_PATH}/etc/nginx/ssl
        fi

        if [ ! -f "${VAGRANT__UBUNTU_COMMON_CONFIGS_PATH}/etc/nginx/ssl/${VAGRANT_SITE_DOMAIN}_bundle.crt" ]; then
            if [ ! -f "${VAGRANT__UBUNTU_COMMON_CONFIGS_PATH}/etc/nginx/ssl/${VAGRANT_SITE_DOMAIN}_private.key" ]; then
                sudo openssl req -new -newkey rsa:1024 -nodes -keyout ${VAGRANT__UBUNTU_COMMON_CONFIGS_PATH}/etc/nginx/ssl/${VAGRANT_SITE_DOMAIN}_private.key -x509 -days 500 -subj /C=RU/ST=Grodno/L=Grodno/O=Companyname/OU=User/CN=${VAGRANT_SITE_DOMAIN}/emailAddress=admin@${VAGRANT_SITE_DOMAIN} -out ${VAGRANT__UBUNTU_COMMON_CONFIGS_PATH}/etc/nginx/ssl/${VAGRANT_SITE_DOMAIN}_bundle.crt > /dev/null 2>&1
            fi
        fi

        sudo cp  ${VAGRANT__UBUNTU_COMMON_CONFIGS_PATH}/etc/nginx/ssl/${VAGRANT_SITE_DOMAIN}_private.key /etc/nginx/ssl/
        sudo cp  ${VAGRANT__UBUNTU_COMMON_CONFIGS_PATH}/etc/nginx/ssl/${VAGRANT_SITE_DOMAIN}_bundle.crt /etc/nginx/ssl/

        log_action_msg "Generated ssl nginx certs for ${VAGRANT_SITE_DOMAIN}"
    fi
done

#if [ -d "$MAIN_SITE_PATH" ]; then
#    sudo cp /etc/nginx/sites-available/vagrant-site-ssl.conf /etc/nginx/sites-available/${MAIN_SITE_DOMAIN}.conf
#    sudo sed -i "s,{SITE_DOMAIN},${MAIN_SITE_DOMAIN},g" /etc/nginx/sites-available/${MAIN_SITE_DOMAIN}.conf
#    sudo sed -i "s,{SITE_PATH},${MAIN_SITE_PATH},g" /etc/nginx/sites-available/${MAIN_SITE_DOMAIN}.conf
#    sudo ln -s /etc/nginx/sites-available/${MAIN_SITE_DOMAIN}.conf /etc/nginx/sites-enabled/ > /dev/null
#fi

log_begin_msg "Update privileges for nginx logs"
sudo chmod 777 -R /var/log/nginx/ > /dev/null
log_end_msg 0

log_begin_msg "Starting nginx"
    sudo service nginx start > /dev/null 2>&1
log_end_msg 0
