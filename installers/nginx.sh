#!/usr/bin/env bash

set -eo pipefail

VERSION='1.10.0'
# https://github.com/simpl/ngx_devel_kit/tags
NGX_DEVEL_KIT_VERSION='0.3.0'
NGX_LUA_VERSION='0.10.6'
DIRECTORY="nginx-$VERSION"
BINARY="$DIRECTORY.tar.gz"

SUBS_DIRECTORY='ngx_http_substitutions_filter_module'

# TODO for Linux also, and figure otu how to find the versions
LUAJIT_BASE=/usr/local/Cellar/luajit/2.0.4_3
LUAJIT_LIB="$LUAJIT_BASE/lib"
LUAJIT_INC="$LUAJIT_BASE/include/luajit-2.0"
OPENSSL=/usr/local/opt/openssl

main() {
    mkdir -p ~/src
    pushd ~/src
        if [[ ! -f "$BINARY" ]]; then 
            curl --location -O "https://nginx.org/download/$BINARY"
        fi
        if [[ ! -d "$DIRECTORY" ]]; then
            tar -xf "$BINARY"
        fi
        if [[ ! -d "$SUBS_DIRECTORY" ]]; then
            git clone git://github.com/yaoweibin/ngx_http_substitutions_filter_module.git
        fi
        if [[ ! -d ngx_devel_kit ]]; then 
            git clone https://github.com/simpl/ngx_devel_kit.git
            pushd ngx_devel_kit
                git checkout "v$NGX_DEVEL_KIT_VERSION"
            popd
        fi
        if [[ ! -d lua-nginx-module ]]; then
            git clone https://github.com/openresty/lua-nginx-module.git
            pushd lua-nginx-module
                git checkout "v$NGX_LUA_VERSION"
            popd
        fi
        export LUAJIT_LIB="$LUAJIT_LIB"
        export LUAJIT_INC="$LUAJIT_INC"
        export EXTRA_LDFLAGS="-L$OPENSSL/lib"
        export EXTRA_CFLAGS="-I$OPENSSL/include"
        pushd "$DIRECTORY"
            ./configure --prefix=$HOME \
                --with-http_sub_module \
                --with-http_ssl_module \
                --with-pcre \
                --with-openssl="$OPENSSL" \
                --with-ld-opt="-Wl,-rpath,$LUAJIT_LIB" \
                --add-module="$HOME/src/$SUBS_DIRECTORY" \
                --add-module="$HOME/src/ngx_devel_kit" \
                --add-module="$HOME/src/lua-nginx-module" 
            make && make install
        popd
    popd
}

main "$@"
