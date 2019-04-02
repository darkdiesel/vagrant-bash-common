#!/usr/bin/env bash

log_begin_msg "Install SendMail"
sudo apt-get install -q -y sendmail sendmail-bin sasl2-bin > /dev/null 2>&1
log_end_msg 0

log_begin_msg "SendMail Config"
sudo sendmailconfig -y > /dev/null 2>&1
log_end_msg 0