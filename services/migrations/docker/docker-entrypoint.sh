#!/bin/bash

set -u # fail if you use variable that is undefined

## variables

db_host=${MYSQL_HOST}
db_name=${MYSQL_DBNAME}
db_user=${MYSQL_USER}
db_password=${MYSQL_PASSWORD}

## functions

wait_for_db() {
    while true; do
        echo 'Attempting to connect to DB'
        nc -z "$db_host" 3306
        if [ $? -ne 0 ]; then
            echo 'Database does not seem to be ready. Sleeping 5 seconds'
            sleep 5
        else
            break
        fi
    done
    echo 'Successfully connected to DB'
}

db_exists() {
  local output

  output=$(mysql \
    -h mysql -u${db_user} -p${db_password} -s -N -e \
    "SELECT schema_name FROM information_schema.schemata WHERE schema_name = '${db_name}'" \
    information_schema)

  if [[ -z "${output}" ]]; then
    return 1 # does not exist
  else
    return 0 # exists
  fi
}

ensure_db_exists() {
    if db_exists; then
        echo "Database ${db_name} exists."
    else
        echo "Creating database ${db_name}"
        mysql -h "${db_host}" -u${db_user} -p${db_password} -e "CREATE DATABASE ${db_name};"
        echo "Creating migrations table"
        mysql -h "${db_host}" -u${db_user} -p${db_password} -e "
            CREATE TABLE ${db_name}.migrations (
                created timestamp not null default now(),
                filename varchar(120) NOT NULL,
                checksum varchar(50) NOT NULL,
                UNIQUE (filename),
                UNIQUE (checksum)
            );"
    fi
}

run_migrations() {
    echo "Running Migrations"
    ./src/migrate.sh all
}

wait_for_filechange() {
    echo "Everything is ready. Waiting for changes."
    read filename < <(inotifyd - \
        src:c \
        sql:c \
    )

    if [ -n "${filename}" ]
    then
        echo "${filename} changed"
    fi
}

sighup_handler() {
    echo "Caught SIGHUP."
    pkill inotifyd
}

## main

if [ $# -eq 0 ]; then
# If no CMD is specified then start Apache once the environment is
# ready.
    cd /usr/migrations

    trap "sighup_handler" HUP

    while true; do
        wait_for_db
        ensure_db_exists
        run_migrations
        wait_for_filechange
    done
else
# Otherwise run the CMD in shell. This makes it possible to use docker
# exec to get a shell and debug the running container.
    exec "$@"
fi
