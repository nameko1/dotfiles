#!/bin/bash
CURRENT_DIR=$(cd $(dirname $0) && pwd)

#ubuntu
# sudo apt remove -y --purge vim vim-runtime vim-common
# sudo apt install -y git build-essential ncurses-dev lua5.2 lua5.2-dev

# install vim source code
git submodule update -i

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

install_package_centos() {
    sudo yum install -y ncurses-devel lua-devel make gcc
}

install_package_ubuntu() {
    sudo apt install -y git build-essential ncurses-dev lua5.2 lua5.2-dev
}

if [ -e /etc/redhat-release ]; then
    install_package_centos
elif [ -e /etc/lsb-release ]; then
    install_package_ubuntu
fi

build_vim
