#!/usr/bin/env bash

log_begin_msg "Setup swap"
# see for more info https://getcomposer.org/doc/articles/troubleshooting.md#proc-open-fork-failed-errors
sudo /bin/dd if=/dev/zero of=/swapfile bs=1M count=1024 > /dev/null 2>&1
sudo /bin/chmod 0600 /swapfile
sudo /sbin/mkswap /swapfile > /dev/null 2>&1
sudo /sbin/swapon /swapfile > /dev/null 2>&1

SWAP_PERMANENT="/swapfile   none    swap    sw    0   0"

if grep -vq "${SWAP_PERMANENT}" /etc/fstab; then
    echo "${SWAP_PERMANENT}" | sudo tee -a /etc/fstab > /dev/null 2>&1
fi
log_end_msg 0