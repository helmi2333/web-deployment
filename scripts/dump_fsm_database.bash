#!/usr/bin/env bash

set -eo pipefail

main() {
    local current_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    local fsm_password=$(cat "$current_directory/../passwords/mysql/fsm.password")
    ssh webf mysqldump \
        --compress \
        --user kevinburke_fsm \
        --host=web237.webfaction.com \
        --password="$fsm_password" \
        --tz-utc \
        --databases \
        kevinburke_fsm > "$current_directory/../databases/fsm.dump"
}

main "$@"
