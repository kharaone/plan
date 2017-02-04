# Check if the string $1 is inside of $2
contains() {
    if [[ -z $1 ]]
    then return 1
    fi

    (echo "$2" | grep -E "\b$1\b" > /dev/null) && \
        return 0 || \
        return 1
}
