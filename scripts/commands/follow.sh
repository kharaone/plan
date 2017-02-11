#!/usr/bin/env bash

set -u

source scripts/lib/colors.sh

help() {
    echo -e "
  Usage: plan follow

  $(bold follow) follows logs
  "
    exit 1
}

follow() {
    docker-compose logs -f --tail=20
}

case "${1: }" in
    completions)
        ;;
    help)
        help
        ;;
    *)
        follow
        ;;
esac
