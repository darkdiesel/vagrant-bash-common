#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' nginx 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing nginx"
    sudo apt-get install nginx -y > /dev/null

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

if [ -d "$MAIN_SITE_DIR" ]; then
    if [ ! -d ${VAGRANT_CONFIGS}"/etc/nginx/ssl" ]; then
        sudo mkdir ${VAGRANT_CONFIGS}/etc/nginx/ssl
    fi

    if [ ! -f "${VAGRANT_CONFIGS}/etc/nginx/ssl/${MAIN_SITE_DOMAIN}_bundle.crt" ]; then
        if [ ! -f "${VAGRANT_CONFIGS}/etc/nginx/ssl/${MAIN_SITE_DOMAIN}_private.key" ]; then
            sudo openssl req -new -newkey rsa:1024 -nodes -keyout ${VAGRANT_CONFIGS}/etc/nginx/ssl/${MAIN_SITE_DOMAIN}_private.key -x509 -days 500 -subj /C=RU/ST=Grodno/L=Grodno/O=Companyname/OU=User/CN=${MAIN_SITE_DOMAIN}/emailAddress=admin@${MAIN_SITE_DOMAIN} -out ${VAGRANT_CONFIGS}/etc/nginx/ssl/${MAIN_SITE_DOMAIN}_bundle.crt > /dev/null
        fi
    fi
fi

log_end_msg 0


log_begin_msg "Remove nginx default hosts"
sudo rm -rf /etc/nginx/sites-enabled/* > /dev/null
log_end_msg 0


log_begin_msg "Copy nginx configs"
sudo cp -R ${VAGRANT_CONFIGS}/etc/nginx/* /etc/nginx/ > /dev/null
log_end_msg 0

log_begin_msg "Create links for nginx hosts"
if [ -d "$MAIN_SITE_DIR" ]; then
    sudo ln -s /etc/nginx/sites-available/${MAIN_SITE_DOMAIN}.conf /etc/nginx/sites-enabled/ > /dev/null
fi
log_end_msg 0

log_begin_msg "Update privileges for nginx logs"
sudo chmod 777 -R /var/log/nginx/ > /dev/null
log_end_msg 0

log_begin_msg "Starting nginx"
    sudo service nginx start > /dev/null 2>&1
log_end_msg 0