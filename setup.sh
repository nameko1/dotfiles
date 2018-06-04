#!/bin/bash

DOT_FILES=()
HOME=$HOME
CURRENT_DIR=$(cd $(dirname $0) && pwd)

while getopts tvz-: o; do
  case "$o" in
    -)
      case "${OPTARG}" in
        all)
          DOT_FILES=('.tmux.conf' '.vimrc' '.zshrc')
          vi=true
          zsh=true;;
        home)
          HOME=${BASH_ARGV}
          if [ ! -e $HOME ]; then
          echo "$HOME is not exist"; exit 1
          fi
          #cd $HOME > /dev/null 2>&1 || echo "$HOME is not exist"; exit 1
          ;;
        tmux)
          DOT_FILES=('.tmux.conf' "${DOT_FILES[@]}")
          ;;
        vim)
          DOT_FILES=('.vimrc' "${DOT_FILES[@]}")
          vi=true;;
      esac;;
    t)
      DOT_FILES=('.tmux.conf' "${DOT_FILES[@]}")
      ;;
    v)
      DOT_FILES=('.vimrc' "${DOT_FILES[@]}")
      vi=true;;
  esac
done

for dotfile in "${DOT_FILES[@]}"
do
  if [ -e $HOME/$dotfile ]; then
    mv $HOME/$dotfile $HOME/$dotfile.old
  fi
  cp $CURRENT_DIR/$dotfile $HOME
done

if [ $vi ]; then
  if [ ! -e $HOME/.vim/toml ]; then
    mkdir -p $HOME/.vim/toml
  fi
  cp -f $CURRENT_DIR/dein.toml $HOME/.vim/toml/
fi

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
