#!/usr/bin/env bash

set -u

source scripts/lib/colors.sh
source scripts/lib/docker.sh
source scripts/lib/functional.sh

help() {
    echo -e "
  Usage: dev attach <service>

  $(bold attach) is used start a bash session within the container
  "
    exit 1
}

attach() {
    docker exec -it $1 bash
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
            attach $1
        else
            echo ""
            echo -e "  $(red Error): Unknown docker container '$1'"
            help
        fi
        ;;
esac
