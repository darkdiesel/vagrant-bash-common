#!/usr/bin/env bash

source ${VAGRANT__OS_SCRIPTS_PATH}/nodejs.sh

#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' npm 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    log_begin_msg "Installing npm"
    sudo apt-get install -y npm > /dev/null 2>&1

    if [[ $? > 0 ]]; then
        log_end_msg 1
    else
        log_end_msg 0
    fi
else
    log_progress_msg "npm installed"
fi