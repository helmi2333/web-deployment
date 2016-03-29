#!/usr/bin/env bash

set -eo pipefail

main() {
    readonly database_name=kevinburke_sta
    readonly database_user=kevinburke_sta
    local current_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    local stage_password=$(cat "$current_directory/../passwords/mysql/stage.password")
    ssh webf mysqldump \
        --compress \
        --user "$database_user" \
        --host=web237.webfaction.com \
        --password="$(printf "%q" ${stage_password})" \
        --tz-utc \
        --databases \
        "$database_name" > "$current_directory/../databases/stage.dump.sql"
}

main "$@"
