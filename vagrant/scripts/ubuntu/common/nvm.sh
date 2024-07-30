#!/usr/bin/env bash

source "${VAGRANT__OS_SCRIPTS_PATH}"/curl.sh

if [ $(nvm --help 2>/dev/null | grep -c "Node Version Manager") -eq 0 ]; then
    if [ -n "$PACKAGES__NVM__VERSION" ]; then
        eval NVM_VERSION='$PACKAGES__NVM__VERSION';
    else
        NVM_VERSION='0.39.7'
    fi;

    log_begin_msg "Installing nvm for root user"

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v"${NVM_VERSION}"/install.sh > /dev/null 2>&1 |  bash  > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi

    log_begin_msg "Installing nvm for vagrant user"

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v"${NVM_VERSION}"/install.sh > /dev/null 2>&1 |  sudo -H -u vagrant bash > /dev/null 2>&1
    sudo -H -u vagrant bash -c 'source ~/.bashrc' > /dev/null 2>&1

    source ~/.nvm/nvm.sh
    source ~/.bashrc
    source ~/.profile

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_progress_msg "nvm already installed"
fi

if [ ! -d ~/.nvm ]; then

  curl https://raw.githubusercontent.com/creationix/nvm/v0.11.1/install.sh | bash
  source ~/.nvm/nvm.sh
  source ~/.profile
  source ~/.bashrc
  nvm install 5.0
  npm install
  npm run front
fi