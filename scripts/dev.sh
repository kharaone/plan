#!/usr/bin/env bash

set -u

# Switch directory to dev.
cd "$(dirname "$(readlink "$0")")/.." || exit

source scripts/lib/colors.sh
source scripts/lib/functional.sh
source scripts/lib/path.sh

help() {
    echo -e "
  Usage: dev <command> [arg] ...

  $(bold dev) is created with $(red ❤) by the developers of Famly. This is a copy-able
  version.

  Options:

    -h, --help                  Output usage information

  Commands:

    help <command>              Output usage information for a specific command
    update                      Update famlydev

  Run \`$(bold dev help command)\` for more information on specific commands.
  "

    exit 1
}

commands() {
    ls ./scripts/*.sh \
    | while read -r path; do echo $(path_basename $(path_notdir ${path})) ; done \
    | while read -r service; do [[ ${service} == "dev" ]] || echo ${service} ; done
}


command="${1: }"
arguments="${@:2}"

case ${command} in
    -h)
        help
        ;;
    --help)
        help
        ;;
    help)
        if [[ -z "${2: }" ]]
        then
            help
        else
            ./scripts/${2}.sh help
        fi
        ;;
    "")
        help
        ;;
    *)
        if contains "$command" "$(commands)"
        then
            ./scripts/$command.sh $arguments
        else
            echo ""
            echo -e "  $(red Error): Unknown command '$command'"
            help
        fi
        ;;
esac
