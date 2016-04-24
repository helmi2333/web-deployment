#!/usr/bin/env bash

set -eo pipefail

main() {
    local current_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    readonly database_name=kevinburke_bb
    readonly database_user=kevinburke_bb
    local password=$(cat "$current_directory/../passwords/mysql/brianburke.password")
    local dump_location="$current_directory/../databases/brianburke.net.dump.sql"

    ssh webf mysqldump \
        --compress \
        --user "$database_user" \
        --host=web237.webfaction.com \
        --password="$(printf "%q" ${password})" \
        --tz-utc \
        --databases \
        "$database_name" > "$dump_location"
}

main "$@"
