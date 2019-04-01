#!/usr/bin/env bash


apt-get install zip unzip -y > /dev/null 2>&1

composer global require drush/drush > /dev/null 2>&1

sudo chmod 777 /etc/default/locale


echo "#path for Drush\nexport PATH='$HOME/.composer/vendor/bin:$PAT'\n" > ~/.bashrc