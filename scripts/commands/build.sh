#!/usr/bin/env bash

set -u

source scripts/lib/colors.sh

help() {
    echo -e "
  Usage: dev up

  $(bold up) Build all or specific service
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
        make build ${2: }
        ;;
esac
