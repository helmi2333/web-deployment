#!/usr/bin/env bash

set -eo pipefail

main() {
    readonly database_name=kevinburke_b_wp
    readonly database_user=kevinburke_b_wp
    local current_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    mkdir -p "$current_directory/../backups"
    local prod_password=$(cat "$current_directory/../passwords/mysql/prod.password")
    local d=$(gdate +"%Y-%m-%d")
    local backup_file="$d.prod.dump.sql"
    local backup_location="$current_directory/../backups/$backup_file"
    ssh wildebeest mysqldump \
        --compress \
        --user "$database_user" \
        --password="$(printf "%q" ${prod_password})" \
        --tz-utc \
        --databases \
        "$database_name" > "$backup_location"
    pushd "$current_directory/../backups"
        7z a "$backup_file.7z" "$backup_file"
    popd
}

main "$@"
