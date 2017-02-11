#!/bin/bash

set -u # fail if you use variable that is undefined

## variables

db_host=${MYSQL_HOST:-"mysql"}
db_name=${MYSQL_DBNAME:-"famly"}
db_user=${MYSQL_USER:-"root"}
db_password=${MYSQL_PASSWORD:-"root"}

## functions

run_pip() {
    echo 'Installing pip packages'
    pip install --egg -r requirements.txt
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
    python src/app.py &
}

reboot() {
    echo "Shutting down python server"
    pkill python
}

wait_for_filechange() {
    echo "Everything is ready. Waiting for changes."
    read i < <(inotifyd - \
        requirements.txt:c
    )
    echo "This changed: $i"
}

sigterm_handler() {
    echo "Caught SIGTERM"
    exit 0
}

sighup_handler() {
    echo "Caught SIGHUP."
    pkill inotifyd
}

## main

cd /workspace

trap "sigterm_handler" TERM
trap "sighup_handler" HUP

while true; do
    run_pip
    wait_for_db
    start_server
    wait_for_filechange
    reboot
done
