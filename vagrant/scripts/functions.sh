if [ ${PACKAGES__MARIADB__INSTALL} == "YES" ]; then
  DB_EXECUTE_USER='/usr/bin/mariadb'
elif [ ${PACKAGES__MYSQL__INSTALL} == "YES" ]; then
  DB_EXECUTE_USER='/usr/bin/mysql'
fi

# Execute sql script
function execute_query () {
     sudo $DB_EXECUTE_USER -u$DB__USER -p$DB__PASS -e "$1" > /dev/null 2>&1
}

# Execute sql file for db
function execute_query_file () {
    sudo $DB_EXECUTE_USER -u$DB__USER -p$DB__PASS $1 < $2  > /dev/null 2>&1
}

function db_installed () {
    VAGRANT_DB_INSTALLED="NO"

    if [ ${PACKAGES__MARIADB__INSTALL} == "YES" ]; then
      if [ $(dpkg-query -W -f='${Status}' mariadb-server 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
        VAGRANT_DB_INSTALLED="YES"
      fi
    elif [ ${PACKAGES__MYSQL__INSTALL} == "YES" ]; then
      if [ $(dpkg-query -W -f='${Status}' mysql-server-$PACKAGES__MYSQL__VERSION 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
        VAGRANT_DB_INSTALLED="YES"
      fi
    fi
}