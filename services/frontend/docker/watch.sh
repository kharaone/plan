#!/bin/bash

set -u

## variables

webpack_server_id=

## functions

install_dependencies() {
    echo "Installing NPM dependencies using yarn"
    yarn install --pure-lockfile
}

start_webpack_in_background() {
    echo "Starting webpack server"
    node_modules/.bin/webpack-dev-server --host 0.0.0.0 &
    webpack_server_pid="$!"
}

wait_for_filechange() {
    echo "Everything is ready. Waiting for changes."

    read -r changed < <(inotifyd - \
        package.json:c \
        yarn.lock:c \
        webpack.config.js:c \
    )

    echo "Detected change ${changed}"
}

kill_processes() {
    echo "Killing Webpack with PID ${webpack_server_pid}"
    kill -2 ${webpack_server_pid}
    wait ${webpack_server_pid}
}

sigterm_handler() {
    echo "Caught SIGTERM"
    exit 0
}

sighup_handler() {
    echo "Caught SIGHUP"
    pkill inotifyd
}

## Main

cd /usr/frontend

trap "sighup_handler" HUP
trap "sigterm_handler" TERM

while true; do
    install_dependencies
    start_webpack_in_background
    wait_for_filechange
    kill_processes
done
