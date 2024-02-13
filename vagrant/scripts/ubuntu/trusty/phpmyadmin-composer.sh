#!/usr/bin/env bash

log_begin_msg "Installing PhpMyAdmin"
sudo composer create-project phpmyadmin/phpmyadmin --repository-url=https://www.phpmyadmin.net/packages.json --no-dev /var/www/pma > /dev/null 2>&1
sudo cp /vagrant/var/www/pma/config.inc.php /var/www/pma/config.inc.php > /dev/null 2>&1
log_end_msg 0

#log_begin_msg "Installing PhpMyAdmin"
#sudo wget -P /var/www/ https://www.phpmyadmin.net/packages.json > /dev/null 2>&1
#sudo composer create-project phpmyadmin/phpmyadmin --repository-url=/var/www/packages.json --no-dev /var/www/pma > /dev/null 2>&1
#sudo cp /vagrant/var/www/pma/config.inc.php /var/www/pma/config.inc.php > /dev/null 2>&1
#sudo rm /var/www/packages.json
#log_end_msg 0