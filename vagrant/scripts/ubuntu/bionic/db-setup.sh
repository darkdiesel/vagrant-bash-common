#!/usr/bin/env bash

if [ "$DB_MAIN_PROVISION_RESET" == "YES" ]; then
    log_action_msg "Remove databases on provision"
    sudo mysql -u$DB_USER -p$DB_PASS -e 'DROP DATABASE IF EXISTS `'.$DB_MAIN_NAME.'`;' > /dev/null 2>&1
    log_success_msg "DB $DB_MAIN_NAME dropped"
    sudo mysql -u$DB_USER -p$DB_PASS -e 'DROP USER IF EXISTS "'.$DB_MAIN_USER.'"@"localhost";' > /dev/null 2>&1
    log_success_msg "User $DB_MAIN_USER dropped"
fi

log_action_msg "Checking existing databases..."

RESULT=`mysqlshow --user=$DB_USER --password=$DB_PASS $DB_MAIN_NAME | grep -v Wildcard | grep -o $DB_MAIN_NAME`
if [ "$RESULT" == "$DB_MAIN_NAME" ]; then
    DB_MAIN_EXIST="YES"
    log_warning_msg "DB $DB_MAIN_NAME exist"
else
    DB_MAIN_EXIST="NO"
    log_success_msg "DB $DB_MAIN_NAME not exist"
fi

#log_progress_msg "$DB_MAIN_NAME exist: $DB_MAIN_EXIST."


log_action_msg  "Creating DB $DB_MAIN_NAME"
if [ -d "$MAIN_SITE_PATH" ] && [ "$DB_MAIN_EXIST" == "NO" ]; then
    sudo mysql -u$DB_USER -p$DB_PASS -e 'CREATE DATABASE `'$DB_MAIN_NAME'` CHARACTER SET utf8 COLLATE utf8_general_ci;'
    log_success_msg "DB $DB_MAIN_NAME created"
else
    log_failure_msg "DB $DB_MAIN_NAME not created"
    log_warning_msg "$DB_MAIN_NAME already exist or site folder not founded"
fi

log_action_msg "Create DBs User"

if [ -d "$MAIN_SITE_PATH" ] && [ "$DB_MAIN_EXIST" == "NO" ]; then
    sudo mysql -u$DB_USER -p$DB_PASS -e 'CREATE USER "'$DB_MAIN_USER'"@"localhost" IDENTIFIED BY "'$DB_MAIN_PASS'";'
    sudo mysql -u$DB_USER -p$DB_PASS -e 'GRANT ALL PRIVILEGES ON `'$DB_MAIN_NAME'`.* TO "'$DB_MAIN_USER'"@"localhost";'

    log_success_msg "User for DB $DB_MAIN_NAME created"
else
    log_failure_msg "User for DB $DB_MAIN_NAME not created"
    log_warning_msg "$DB_MAIN_NAME already exist or site folder not founded"
fi

log_begin_msg "Flush mysql privileges"
sudo mysql -u$DB_USER -p$DB_PASS -e "FLUSH PRIVILEGES;"
log_end_msg 0


log_action_msg "Run db scripts"

if [ -d "$MAIN_SITE_PATH" ] && [ "$DB_MAIN_EXIST" == "NO" ]; then
    if [ -f "${VAGRANT_DATA_FOLDER}/db-backups/db.sql" ]; then
        log_action_msg "Running script for $DB_MAIN_NAME"

        sudo mysql -u$DB_USER -p$DB_PASS $DB_MAIN_NAME < ${VAGRANT_DATA_FOLDER}/db-backups/db.sql

        log_success_msg "Script executed for DB $DB_MAIN_NAME"
    else
        log_failure_msg "Script not founded for DB $DB_MAIN_NAME "
    fi
else
    log_failure_msg "Script not executed for DB $DB_MAIN_NAME not created"
    log_warning_msg "$DB_MAIN_NAME already exist or site folder not founded"
fi