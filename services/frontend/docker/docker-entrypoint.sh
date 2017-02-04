#!/bin/bash

if [ $# -eq 0 ]; then
    # We only care about undefined variables when running
    # the standard command.
    set -u
fi

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
    pkill inotifyd
}

## Main

if [ $# -eq 0 ]; then
# If no CMD is specified then start the development server
    cd /usr/frontend

    trap "sighup_handler" HUP

    while true; do
        install_dependencies
        start_webpack_in_background
        wait_for_filechange
        kill_processes
    done
else
# Otherwise run the CMD in shell. This makes it possible to use docker
# exec to get a shell and debug the running container.
    echo "Running command '$@'"
    exec "$@"
fi
