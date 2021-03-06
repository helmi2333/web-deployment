#!/bin/bash

set -exo pipefail

main() {
    local current_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    local fsm_password=$(cat "$current_directory/../passwords/mysql/fsm.password")
    ssh wildebeest-root mysql -uroot < "$current_directory/../databases/fsm.dump"
    ssh wildebeest-root "mysql --execute 'GRANT ALL ON kevinburke_fsm.* to kevinburke_fsm@localhost identified by \"226ab754\";'"
}

main "$@"
