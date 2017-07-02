#!/usr/bin/env bash

set -e

main() {
    local backup_file="mysql-$(uname -n)-$(date +%Y-%m-%d_%H-%M-%S)"
    /usr/bin/mysqldump --all-databases --single-transaction --user=root > "/root/tmp/$backup_file"
    /usr/local/bin/tarsnap --print-stats -c \
        -f "$backup_file" "/root/tmp/$backup_file"
}

main "$@"
