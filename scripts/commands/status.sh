#!/usr/bin/env bash

set -u

source scripts/lib/colors.sh
source scripts/lib/path.sh

help() {
    echo -e "
  Usage: plan status

  $(bold status) gives a brief overview of the development environment.
  "
    exit 1
}

currenst_plan() {
   echo  $(path_basename $(path_notdir $(readlink docker-compose.yml)))
}

status() {
    echo ""
    echo -e "Current plan: $(bold $(currenst_plan))"
    echo ""
    docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
    echo ""
}

case "${1: }" in
    completions)
        ;;
    help)
        help
        ;;
    *)
        status
        ;;
esac
