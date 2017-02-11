#!/usr/bin/env bash

set -u

source scripts/lib/colors.sh

help() {
    echo -e "
  Usage: plan up

  $(bold up) starts the current environment stack.
  "
    exit 1
}

case "${1: }" in
    completions)
        ;;
    help)
        help
        ;;
    *)
        docker-compose down
        ;;
esac
