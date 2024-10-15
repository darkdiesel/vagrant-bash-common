#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' golang-go 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing golang-go"
    sudo apt-get install -y golang-go > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_action_msg "Update .profile with GOPATH"
        mkdir gocode
        echo "export GOPATH=$HOME/gocode" >> ~/.profile
        source ~/.profile > /dev/null 2>&1

        log_end_msg 0
    fi
else
    log_action_msg "golang-go already installed"
fi