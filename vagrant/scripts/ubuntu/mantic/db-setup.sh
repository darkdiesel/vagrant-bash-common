#!/usr/bin/env bash

function execute_query () {
     echo "$1"
     sudo /usr/bin/mariadb -u$DB__USER -p$DB__PASS -e "$1"
}

for i in `seq 1 ${SITES__COUNT}`;
do
    eval VAGRANT_SITE_DOMAIN='$'SITES__SITE_"$i"__DOMAIN
    eval VAGRANT_SITE_DIR='$'SITES__SITE_"$i"__DIR
    eval VAGRANT_SITE_PATH='$'SITES__SITE_"$i"__PATH

    eval VAGRANT_DB_NAME='$'SITES__SITE_"$i"__DB__NAME
    eval VAGRANT_DB_USER='$'SITES__SITE_"$i"__DB__USER
    eval VAGRANT_DB_PASS='$'SITES__SITE_"$i"__DB__PASS
    eval VAGRANT_DB_PROVISION_RESET='$'SITES__SITE_"$i"__DB__PROVISION_RESET

    if [ ! -n "$VAGRANT_DB_NAME" ]; then
        log_warning_msg "DB__NAME not setupped for site ${VAGRANT_SITE_DOMAIN}"
        continue
    fi

    if [ ! -n "$VAGRANT_DB_PROVISION_RESET" ]; then
      log_warning_msg "DB ${VAGRANT_DB_NAME} don't has personal provision settings we will get global"

      if [ ! -n "$DB__PROVISION_RESET" ]; then
        VAGRANT_DB_PROVISION_RESET=DB__PROVISION_RESET
      fi
    fi

    if [ "$VAGRANT_DB_PROVISION_RESET" == "YES" ]; then
        log_action_msg "Removing DB on provision if exist"
        execute_query "DROP DATABASE IF EXISTS \`${VAGRANT_DB_NAME}\`;"
        log_success_msg "DB $VAGRANT_DB_NAME dropped"

        if [ -n "$VAGRANT_DB_USER" ]; then
            log_action_msg "Removing ${VAGRANT_DB_USER} on provision if exist"
            execute_query "DROP USER IF EXISTS '${VAGRANT_DB_USER}'@'localhost';"
            log_success_msg "User $VAGRANT_DB_USER dropped"
        fi
    fi

    log_action_msg "Checking existing DB ${VAGRANT_DB_NAME}"

    VAGRANT_DB_EXIST="NO"

    if [ -d "/var/lib/mysql/$VAGRANT_DB_NAME" ] ; then
        VAGRANT_DB_EXIST="YES"
        log_warning_msg "DB ${VAGRANT_DB_NAME} already exist!"
        continue
    else
        log_success_msg "DB ${VAGRANT_DB_NAME} not exist!"
    fi

    log_action_msg  "Creating DB $VAGRANT_DB_NAME"

    if [ -d "$VAGRANT_SITE_PATH" ] && [ "$VAGRANT_DB_EXIST" == "NO" ]; then
        execute_query "CREATE DATABASE \`${VAGRANT_DB_NAME}\` CHARACTER SET utf8 COLLATE utf8_general_ci;"
        log_success_msg "DB ${VAGRANT_DB_NAME} created"
    else
        log_failure_msg "DB ${VAGRANT_DB_NAME} not created"
        log_warning_msg "DB ${VAGRANT_DB_NAME} already exist or site folder ${VAGRANT_SITE_PATH} not founded"
    fi

    if [ -n "$VAGRANT_DB_USER" ]; then
        if [ -n "$VAGRANT_DB_PASS" ]; then
            log_action_msg "Create DB USER ${VAGRANT_DB_USER}"

            if [ -d "$VAGRANT_SITE_PATH" ] && [ "$VAGRANT_DB_EXIST" == "NO" ]; then
                execute_query "CREATE USER '${VAGRANT_DB_USER}'@'localhost' IDENTIFIED BY '${VAGRANT_DB_PASS}';"
                execute_query "GRANT ALL PRIVILEGES ON \`${VAGRANT_DB_NAME}\`.* TO '${VAGRANT_DB_USER}'@'localhost';"

                log_success_msg "User ${VAGRANT_DB_USER} for DB ${VAGRANT_DB_NAME} created"
            else
                log_failure_msg "User ${VAGRANT_DB_USER} for DB ${VAGRANT_DB_NAME} not created"
                log_warning_msg "DB ${VAGRANT_DB_NAME} already exist or site folder ${VAGRANT_SITE_PATH} not founded"
            fi
        else
            log_warning_msg "DB_PASS for ${VAGRANT_DB_USER} not setupped in DB: ${VAGRANT_DB_NAME}. USER NOT CREATED"
        fi
    else
        log_warning_msg "DB_USER not setupped in DB: ${VAGRANT_DB_NAME}. USER NOT CREATED"
    fi

    log_begin_msg "Flush mysql privileges"
    execute_query "FLUSH PRIVILEGES;"
    log_end_msg 0

    log_action_msg "Run db scripts"

    if [ -d "$VAGRANT_SITE_PATH" ] && [ "$VAGRANT_DB_EXIST" == "NO" ]; then
        if [ -f "${VAGRANT__DATA_FOLDER}/dumps/${VAGRANT_DB_NAME}.sql" ]; then
            log_action_msg "Running script for $VAGRANT_DB_NAME"

            sudo /usr/bin/mariadb -u$DB__USER -p$DB__PASS $VAGRANT_DB_NAME < ${VAGRANT__DATA_FOLDER}/dumps/${VAGRANT_DB_NAME}.sql

            log_success_msg "Script executed for DB $VAGRANT_DB_NAME"
        else
            log_failure_msg "Script not founded for DB $VAGRANT_DB_NAME "
        fi
    else
        log_failure_msg "Script not executed for DB $VAGRANT_DB_NAME"
        log_warning_msg "DB ${VAGRANT_DB_NAME} already exist or site folder ${VAGRANT_SITE_PATH} not founded"
    fi
done