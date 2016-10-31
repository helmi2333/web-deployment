#!/usr/bin/env bash

set -eo pipefail

VERSION='1.10.2'
# https://github.com/simpl/ngx_devel_kit/tags
NGX_DEVEL_KIT_VERSION='0.3.0'
NGX_LUA_VERSION='0.10.6'
DIRECTORY="nginx-$VERSION"
BINARY="$DIRECTORY.tar.gz"

SUBS_DIRECTORY='ngx_http_substitutions_filter_module'

# TODO for Linux also, and figure out how to find the versions
LUAJIT_BASE=$HOME
LUAJIT_LIB="$LUAJIT_BASE/lib"
LUAJIT_INC="$LUAJIT_BASE/include/luajit-2.0"


LUAJIT_VERSION="2.0.4"
LUAJIT_DIRECTORY="LuaJIT-$LUAJIT_VERSION"
LUAJIT_BINARY="$LUAJIT_DIRECTORY.tar.gz"

OPENSSL_VERSION='1.0.2j'
OPENSSL_DIRECTORY='openssl-1.0.2j'
OPENSSL_BINARY="$OPENSSL_DIRECTORY.tar.gz"
OPENSSL="$HOME/src/$OPENSSL_DIRECTORY"

main() {
    mkdir -p ~/src
    pushd ~/src
        if [[ ! -f "OPENSSL_BINARY" ]]; then
            curl --location -O "https://www.openssl.org/source/$OPENSSL_BINARY"
        fi
        if [[ ! -d "$OPENSSL_DIRECTORY" ]]; then
            tar -xf "$OPENSSL_BINARY"
        fi
        if [[ ! -f "$LUAJIT_BINARY" ]]; then
            curl --location -O "https://luajit.org/download/$LUAJIT_BINARY"
        fi
        if [[ ! -d "$LUAJIT_DIRECTORY" ]]; then
            tar -xf "$LUAJIT_BINARY"
        fi
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
        pwd
        pushd "$LUAJIT_DIRECTORY"
            make PREFIX=$HOME
            make install PREFIX=$HOME
        popd
        export LUAJIT_LIB="$LUAJIT_LIB"
        export LUAJIT_INC="$LUAJIT_INC"
        export EXTRA_LDFLAGS="-L$OPENSSL/lib"
        export EXTRA_CFLAGS="-I$OPENSSL/include"
        pushd "$DIRECTORY"
            ./configure --prefix=$HOME \
                --sbin-path=$HOME/sbin \
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
