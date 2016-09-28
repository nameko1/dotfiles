#!/bin/bash

cp .vimrc ~/
cp .zshrc ~/
cp .tmux ~/

mkdir -p ~/.vim/bundle
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
