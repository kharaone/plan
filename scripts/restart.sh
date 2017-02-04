#!/usr/bin/env bash

set -u

source scripts/lib/colors.sh
source scripts/lib/docker.sh
source scripts/lib/functional.sh

help() {
    echo -e "
  Usage: dev nuke <service>

  $(bold nuke) is used give a service a thermonuclear kick.

  The service will be excised from the current space-time and rebooted afterwards.
  "
    exit 1
}

restart() {
    docker-compose stop $1
    docker-compose rm -f $1
    docker-compose up -d $1 
}

case "${1: }" in
    completions)
        docker_containers
        ;;
    help)
       help
       ;;
    "")
        help
        ;;
    *)
        if contains "$1" "$(docker_containers)"
        then
            restart $1
        else
            echo ""
            echo -e "  $(red Error): Unknown docker container '$1'"
            help
        fi
        ;;
esac
