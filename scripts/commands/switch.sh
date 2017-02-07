#!/usr/bin/env bash

set -u

source scripts/lib/colors.sh
source scripts/lib/functional.sh

help() {
    echo -e "
  Usage: famlydev switch <environment>

  $(bold switch) is used to between the various development stacks
  "
    exit 1
}

presets() {
    find ./presets -name "*.yml" \
    | while read -r path; do basename "$path" ; done \
    | while read -r filename; do echo "${filename%.*}" ; done
}

switch() {
    ln -sf "./presets/$1.yml" docker-compose.yml
    echo "Switched to $1"
}


case "${1: }" in
    completions)
        presets
        ;;
    help)
       help
       ;;
    "")
        help
        ;;
    *)
        if contains "$1" "$(presets)"
        then
            switch $1
        else
            echo ""
            echo -e "  $(red Error): Unknown preset '$1'"
            help
        fi
        ;;
esac
