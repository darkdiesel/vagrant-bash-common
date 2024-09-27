#!/usr/bin/env bash

source "${VAGRANT__OS_SCRIPTS_PATH}"/curl.sh

if [ $(nvm --help 2>/dev/null | grep -c "Node Version Manager") -eq 0 ]; then
    if [ -n "$PACKAGES__NVM__VERSION" ]; then
        eval NVM_VERSION='$PACKAGES__NVM__VERSION';
    else
        NVM_VERSION='0.40.1'
    fi;

    log_begin_msg "Installing nvm for root user"

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v"${NVM_VERSION}"/install.sh > /dev/null 2>&1 |  bash  > /dev/null 2>&1

    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi

    log_begin_msg "Installing nvm for vagrant user"

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v"${NVM_VERSION}"/install.sh > /dev/null 2>&1 |  sudo -H -u vagrant bash > /dev/null 2>&1
    sudo -H -u vagrant bash -c 'source ~/.bashrc' > /dev/null 2>&1

    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

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