#!/usr/bin/env bash

set -u

source scripts/lib/colors.sh

help() {
    echo -e "
  Usage: stack time

  $(bold time) synchronizes the time in the Docker VM with the host
  "
    exit 1
}

settime() {
    docker run --rm --privileged alpine:3.4 \
      date -u --set "$(date -u +"%Y-%m-%d %H:%M:%S")"
}

case "${1: }" in
    completions)
        ;;
    help)
        help
        ;;
    *)
        settime
        ;;
esac
