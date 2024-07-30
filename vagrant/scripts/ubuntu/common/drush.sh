#!/usr/bin/env bash

source ${VAGRANT__OS_SCRIPTS_PATH}/composer.sh
source ${VAGRANT__OS_SCRIPTS_PATH}/zip.sh
source ${VAGRANT__OS_SCRIPTS_PATH}/unzip.sh

log_begin_msg "Installing drush via composer"
sudo -H -u vagrant bash -c "composer global require drush/drush:${PACKAGES__DRUSH__VERSION}" > /dev/null 2>&1
log_end_msg 0

sudo chmod 777 /home/vagrant/.bashrc

log_begin_msg "Update .bashrc with drush path"
sudo echo '#path for Drush' >> /home/vagrant/.bashrc
sudo echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> /home/vagrant/.bashrc
log_end_msg 0

source ~/.bashrc > /dev/null 2>&1