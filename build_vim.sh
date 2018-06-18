#!/bin/bash
CURRENT_DIR=$(cd $(dirname $0) && pwd)

#ubuntu
# sudo apt remove -y --purge vim vim-runtime vim-common
# sudo apt install -y git build-essential ncurses-dev lua5.2 lua5.2-dev

build_vim() {
  cd $CURRENT_DIR/vim

  ./configure \
    --enable-luainterp=dynamic \
    --enable-gpm \
    --enable-fail-if-missing \
    --with-features=huge \
    --disable-selinux \
    --enable-luainterp \
    --enable-cscope \
    --enable-fontset \
    --enable-multibyte

  make
  sudo make install
}

build_vim
