#!/bin/bash

DOT_FILES=()
CURRENT_DIR=$(cd $(dirname $0) && pwd)

DOT_FILES=('.tmux.conf' '.zshrc')

for dotfile in "${DOT_FILES[@]}"
do
  ln -sf $CURRENT_DIR/$dotfile $HOME/$dotfile
done

# vi setting
if [ ! -e $HOME/.vim ]; then
  mkdir $HOME/.vim
fi
ln -sf $CURRENT_DIR/vimrc/rc/ $HOME/.vim/rc
ln -sf $CURRENT_DIR/vimrc/vimrc $HOME/.vim/vimrc
ln -sf $CURRENT_DIR/vimrc/autoload/ $HOME/.vim/autoload
ln -sf $CURRENT_DIR/vimrc/plugin/ $HOME/.vim/plugin

# zsh setting
if [ ! -e $HOME/.zshenv ]; then
  touch $HOME/.zshenv
fi

if [ ! -e $HOME/.zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh-syntax-highlighting
fi

if [ ! -e $HOME/.zsh-interactive-cd ]; then
  git clone https://github.com/changyuheng/zsh-interactive-cd.git $HOME/.zsh-interactive-cd
fi

IS_AG=`which ag`
if [ -z $IS_AG ];then
  echo '''
  Please, Install the silver searcher
  https://github.com/ggreer/the_silver_searcher

  Ubuntu:
   apt install silversearcher-ag
  CentOS:
   yum install the_silver_searcher
  '''
fi

#vim lint
# pip install vim-vint
