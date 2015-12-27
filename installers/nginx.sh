#!/bin/bash

set -e

VERSION='1.8.0'
DIRECTORY="nginx-$VERSION"
BINARY="$DIRECTORY.tar.gz"

SUBS_DIRECTORY='ngx_http_substitutions_filter_module'

main() {
    mkdir -p ~/src
    pushd ~/src
        if [ ! -f "$BINARY" ]; then 
            curl --location -O "http://nginx.org/download/$BINARY"
        fi
        if [ ! -d "$DIRECTORY" ]; then
            tar -xf "$BINARY"
        fi
        if [[ ! -d "$SUBS_DIRECTORY" ]]; then
            git clone git://github.com/yaoweibin/ngx_http_substitutions_filter_module.git
        fi
        pushd "$DIRECTORY"
            ./configure --prefix=$HOME --with-http_sub_module --with-http_ssl_module --with-pcre --add-module="$HOME/src/$SUBS_DIRECTORY"
            make && make install
            if [ $? -gt 0 ]; then
                exit 2
            fi
        popd
    popd
}

main "$@"
