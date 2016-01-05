#!/bin/bash

set -ex

main() {
  local version='5.6.16'
  local directory="php-$version"
  local binary="$directory.tar.bz2"
  mkdir -p $HOME/src
  pushd $HOME/src
    if [[ ! -f "$binary" ]]; then
      curl --location --output "$binary" "http://us1.php.net/get/$binary/from/this/mirror"
    fi

    if [[ ! -d "$directory" ]]; then
        tar -xf "$binary"
    fi

    pushd "$directory"
        ./configure --enable-pcntl --with-curl --with-mcrypt --enable-mbstring \
            --with-openssl --enable-fpm --with-mysql --with-libedit \
            --with-libdir=/lib/x86_64-linux-gnu
        make
        make install
    popd
  popd
}

main "$@"
