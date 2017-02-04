#!/bin/bash

set -u # fail if you use variable that is undefined

## variables

db_host=${MYSQL_HOST}
db_name=${MYSQL_DBNAME}
db_user=${MYSQL_USER}
db_password=${MYSQL_PASSWORD}
mode=${MODE}

## functions

migrations() {
    ls './sql/'
}

check_state() {
    filename=$1
    file_checksum=$2

    stored_checksum=$(mysql -h ${db_host} -u${db_user} -p${db_password} -D ${db_name} -s -N -e "
        SELECT checksum
        FROM migrations
        WHERE filename = '${filename}'
    ")

    if [ -z "${stored_checksum}" ]
    then
        echo "missing"
    else
        if [ "${file_checksum}" == "${stored_checksum}" ]
        then
            echo "applied"
        else
            echo "modified"
        fi
    fi
}

apply_migration() {
    filename=$1
    checksum=$2
    path="./sql/${filename}"

    mysql -h ${db_host} -u${db_user} -p${db_password} -D ${db_name} -s -N < "${path}"

    if [ $? -gt 0 ]
    then
        echo "ERROR: Failed to apply ${filename}"
    else
        mysql -h ${db_host} -u${db_user} -p${db_password} -D ${db_name} -s -N -e "
              INSERT INTO migrations (filename, checksum)
              VALUES ('${filename}', '${checksum}')
        "
    fi
}

run_migration() {
    filename=$1

    checksum=$(md5sum "./sql/${filename}" | awk '{ print $1 }')
    state=$(check_state "${filename}" "${checksum}")

    case ${state} in
        "missing")
            echo "${filename}: Running with checksum ${checksum}"
            apply_migration ${filename} ${checksum}
            ;;
        "applied")
            echo "${filename}: Already applied. Skipped."
            ;;
        "modified")
            case ${mode} in
                development)
                    echo "${filename}: Was modified. Rerunning."
                    reapply_migration ${filename}
                    ;;
                production)
                    echo "{filename}: Was modified since last execution. Aborting"
                    exit 1
                    ;;
                *)
                    echo "Unknown mode: ${mode}"
                    exit 1
                    ;;
            esac
            ;;
    esac
}

reapply_migration() {
    filename=$1
    checksum=$(md5sum "./sql/${filename}" | awk '{ print $1 }')

    mysql -h ${db_host} -u${db_user} -p${db_password} -D ${db_name} -s -N -e "
        DELETE FROM migrations WHERE filename = '${filename}'
    "

    apply_migration "${filename}" "${checksum}"
}

run_all_migrations() {
    for filename in $(migrations)
    do
        run_migration "$filename"
    done
}

case "${1: }" in
    "all")
        run_all_migrations
        ;;
    "apply")
        echo "Applying ${2}"
        reapply_migration "${2}"
        ;;
    "clar") ;;
esac
