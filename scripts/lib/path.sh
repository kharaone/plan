# Extracts all but the directory-part of the file name
path_notdir() {
    echo "${1##*/}"
}

# Extracts all but the suffix of the file name
path_basename() {
    echo "${1%.*}"
}
