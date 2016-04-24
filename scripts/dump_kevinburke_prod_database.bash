#!/usr/bin/env bash

set -eo pipefail

main() {
    readonly database_name=kevinburke_b_wp
    readonly database_user=kevinburke_b_wp
    local current_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    local prod_password=$(cat "$current_directory/../passwords/mysql/prod.password")
    ssh webf mysqldump \
        --compress \
        --user "$database_user" \
        --host=web237.webfaction.com \
        --password="$(printf "%q" ${prod_password})" \
        --tz-utc \
        --databases \
        "$database_name" > "$current_directory/../databases/prod.dump.sql"
}

main "$@"
