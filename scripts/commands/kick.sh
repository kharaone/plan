#!/usr/bin/env bash

set -u

source scripts/lib/colors.sh
source scripts/lib/docker.sh
source scripts/lib/functional.sh

help() {
    echo -e "
  Usage: famlydev kick <service>

  $(bold kick) is used give a service a soft kick.

  The service will do a reboot without restarting the container.
  "
    exit 1
}

kick() {
    docker exec -it $1 kill -HUP 1
    echo "Kicked $1"
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
            kick $1
        else
            echo ""
            echo -e "  $(red Error): Unknown docker container '$1'"
            help
        fi
        ;;
esac
