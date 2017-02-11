#!/usr/bin/env bash

set -u

source scripts/lib/colors.sh
source scripts/lib/docker.sh
source scripts/lib/functional.sh

help() {
    echo -e "
  Usage: plan db <command>

  $(bold db) Is used to manipulate the database in various ways.
  "
    exit 1
}

commands="clean migrate watch"

case "${1: }" in
    completions)
        echo ${commands}
        ;;
    help)
       help
       ;;
    "")
        help
        ;;
    *)
        if contains "$1" "${commands}"
        then
            docker-compose run migrations '/usr/migrations/src/migrate.sh' $1
        else
            echo ""
            echo -e "  $(red Error): Unknown command $1"
            help
        fi
        ;;
esac
