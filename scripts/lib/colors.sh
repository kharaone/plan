if [[ $TERM == "dumb" ]]
then
    bold=
    bold_red=
    bold_blue=
    bold_green=
    reset=
else
    bold="\\033[1m"
    bold_red="\\033[1;31m"
    bold_blue="\\033[1;34m"
    bold_green="\\033[1;32m"
    reset="\\033[0m"
fi

bold() {
    echo "${bold}${@}${reset}"
}

red() {
    echo "${bold_red}${@}${reset}"
}

green() {
    echo "${bold_green}${@}${reset}"
}
