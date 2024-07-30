#!/usr/bin/env bash

source ${VAGRANT__OS_SCRIPTS_PATH}/curl.sh

if [ $(nvm --help 2>/dev/null | grep -c "Node Version Manager") -eq 0 ]; then
    if [ -n "$PACKAGES__NVM__VERSION" ]; then
        eval NVM_VERSION='$PACKAGES__NVM__VERSION';
    else
        NVM_VERSION='0.39.7'
    fi;

    log_begin_msg "Installing nvm"

    NVM_COMMON_FILE="/etc/profile.d/nvm.sh"

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | NVM_DIR=/usr/local/nvm bash

    sudo touch $NVM_COMMON_FILE

    sudo echo '#!/usr/bin/env bash' >> $NVM_COMMON_FILE
    sudo echo 'export NVM_DIR=/usr/local/nvm' >> $NVM_COMMON_FILE
    sudo echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh' >> $NVM_COMMON_FILE

    chmod 755 $NVM_COMMON_FILE

    source ~/.bashrc > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_progress_msg "nvm already installed"
fi