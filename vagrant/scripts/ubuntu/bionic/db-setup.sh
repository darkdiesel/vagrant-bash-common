#!/usr/bin/env bash

for i in `seq 1 ${SITES__COUNT}`;
do
    eval VAGRANT_SITE_DOMAIN='$'SITES__SITE_"$i"__DOMAIN
    eval VAGRANT_SITE_DIR='$'SITES__SITE_"$i"__DIR
    eval VAGRANT_SITE_PATH='$'SITES__SITE_"$i"__PATH

    eval VAGRANT_DB_NAME='$'SITES__SITE_"$i"__DB__NAME
    eval VAGRANT_DB_USER='$'SITES__SITE_"$i"__DB__USER
    eval VAGRANT_DB_PASS='$'SITES__SITE_"$i"__DB__PASS
    eval VAGRANT_DB_PROVISION_RESET='$'SITES__SITE_"$i"__DB__PROVISION_RESET


    if [ "$VAGRANT_DB_PROVISION_RESET" == "YES" ]; then
        log_action_msg "Remove databases on provision"
        sudo mysql -u$DB__USER -p$DB__PASS -e 'DROP DATABASE IF EXISTS `'.$VAGRANT_DB_NAME.'`;' > /dev/null 2>&1
        log_success_msg "DB $VAGRANT_DB_NAME dropped"
        sudo mysql -u$DB__USER -p$DB__PASS -e 'DROP USER IF EXISTS "'.$VAGRANT_DB_USER.'"@"localhost";' > /dev/null 2>&1
        log_success_msg "User $VAGRANT_DB_USER dropped"
    fi

    log_action_msg "Checking existing databases..."

    RESULT=`mysqlshow --user=$DB__USER --password=$DB__PASS $VAGRANT_DB_NAME | grep -v Wildcard | grep -o $VAGRANT_DB_NAME`
    if [ "$RESULT" == "$VAGRANT_DB_NAME" ]; then
        VAGRANT_DB_EXIST="YES"
        log_warning_msg "DB $VAGRANT_DB_NAME exist"
    else
        VAGRANT_DB_EXIST="NO"
        log_success_msg "DB $VAGRANT_DB_NAME not exist"
    fi

    #log_progress_msg "$VAGRANT_DB_NAME exist: $VAGRANT_DB_EXIST."

    log_action_msg  "Creating DB $VAGRANT_DB_NAME"

    if [ -d "$VAGRANT_SITE_PATH" ] && [ "$VAGRANT_DB_EXIST" == "NO" ]; then
        sudo mysql -u$DB__USER -p$DB__PASS -e 'CREATE DATABASE `'$VAGRANT_DB_NAME'` CHARACTER SET utf8 COLLATE utf8_general_ci;'
        log_success_msg "DB $VAGRANT_DB_NAME created"
    else
        log_failure_msg "DB $VAGRANT_DB_NAME not created"
        log_warning_msg "$VAGRANT_DB_NAME already exist or site folder not founded"
    fi

    log_action_msg "Create DBs User"

    if [ -d "$VAGRANT_SITE_PATH" ] && [ "$VAGRANT_DB_EXIST" == "NO" ]; then
        sudo mysql -u$DB__USER -p$DB__PASS -e 'CREATE USER "'$VAGRANT_DB_USER'"@"localhost" IDENTIFIED BY "'$VAGRANT_DB_PASS'";'
        sudo mysql -u$DB__USER -p$DB__PASS -e 'GRANT ALL PRIVILEGES ON `'$VAGRANT_DB_NAME'`.* TO "'$VAGRANT_DB_USER'"@"localhost";'

        log_success_msg "User for DB $VAGRANT_DB_NAME created"
    else
        log_failure_msg "User for DB $VAGRANT_DB_NAME not created"
        log_warning_msg "$VAGRANT_DB_NAME already exist or site folder not founded"
    fi

    log_begin_msg "Flush mysql privileges"
    sudo mysql -u$DB__USER -p$DB__PASS -e "FLUSH PRIVILEGES;"
    log_end_msg 0

    log_action_msg "Run db scripts"

    if [ -d "$VAGRANT_SITE_PATH" ] && [ "$VAGRANT_DB_EXIST" == "NO" ]; then
        if [ -f "${VAGRANT__DATA_FOLDER}/db-backups/${VAGRANT_DB_NAME}.sql" ]; then
            log_action_msg "Running script for $VAGRANT_DB_NAME"

            sudo mysql -u$DB__USER -p$DB__PASS $VAGRANT_DB_NAME < ${VAGRANT__DATA_FOLDER}/db-backups/${VAGRANT_DB_NAME}.sql

            log_success_msg "Script executed for DB $VAGRANT_DB_NAME"
        else
            log_failure_msg "Script not founded for DB $VAGRANT_DB_NAME "
        fi
    else
        log_failure_msg "Script not executed for DB $VAGRANT_DB_NAME not created"
        log_warning_msg "$VAGRANT_DB_NAME already exist or site folder not founded"
    fi
done