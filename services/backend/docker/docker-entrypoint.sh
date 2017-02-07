#!/bin/bash

set -u # fail if you use variable that is undefined

## variables

db_host=${MYSQL_HOST:-"mysql"}
db_name=${MYSQL_DBNAME:-"famly"}
db_user=${MYSQL_USER:-"root"}
db_password=${MYSQL_PASSWORD:-"root"}

## functions

run_pip() {
    if md5sum -c -s .requirements.checksum.txt;
    then
        echo 'Skipping PIP packages'
    else
        echo 'Installing pip packages'
        pip install --egg --no-cache-dir -r requirements.txt
        md5sum requirements.txt > .requirements.checksum.txt
    fi;
}

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

start_server() {
    python src/app.py
}

wait_for_filechange() {
    echo "Everything is ready. Waiting for changes."
    read i < <(inotifyd - \
        requirements.txt:c
    )
    echo "This changed: $i"
}

sighup_handler() {
    echo "Caught SIGHUP."
    pkill python
    pkill inotifyd
}

## main

if [ $# -eq 0 ]; then
# If no CMD is specified then start Apache once the environment is
# ready.
    cd /workspace

    trap "sighup_handler" HUP

    while true; do
        run_pip
        wait_for_db
        start_server
        wait_for_filechange
    done
else
# Otherwise run the CMD in shell. This makes it possible to use docker
# exec to get a shell and debug the running container.
    exec "$@"
fi