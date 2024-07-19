#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' sendmail 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing sendmail"

    sudo apt-get install -q -y sendmail sendmail-bin sasl2-bin > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi

    log_begin_msg "SendMail Config"
    sudo sendmailconfig -y > /dev/null 2>&1
    log_end_msg 0
else
    log_progress_msg "software-properties-common already installed"
fi