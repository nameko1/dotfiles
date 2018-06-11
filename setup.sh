#!/bin/bash

DOT_FILES=()
CURRENT_DIR=$(cd $(dirname $0) && pwd)

DOT_FILES=('.tmux.conf' '.vimrc')

for dotfile in "${DOT_FILES[@]}"
do
  if [ -e $HOME/$dotfile ]; then
    mv $HOME/$dotfile $HOME/$dotfile.old
  fi
  cp $CURRENT_DIR/$dotfile $HOME
done

# vi setting
if [ ! -e $HOME/.vim/toml ]; then
  mkdir -p $HOME/.vim/toml
fi
cp -f $CURRENT_DIR/dein.toml $HOME/.vim/toml/

# zsh setting
if [ ! -e $HOME/.zshenv ]; then
  echo 'export ZDOTDIR='$CURRENT_DIR > $HOME/.zshenv
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
