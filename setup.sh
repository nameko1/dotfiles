#!/bin/bash

DOT_FILES=()
HOME=$HOME
CURRENT_DIR=$(cd $(dirname $0) && pwd)

while getopts tvz-: o; do
  case "$o" in
    -)
      case "${OPTARG}" in
        all)
          DOT_FILES=('.tmux.conf .vimrc .zshrc')
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
        zsh)
          DOT_FILES=('.zshrc' "${DOT_FILES[@]}")
          zsh=true;;
      esac;;
    t)
      DOT_FILES=('.tmux.conf' "${DOT_FILES[@]}")
      ;;
    v)
      DOT_FILES=('.vimrc' "${DOT_FILES[@]}")
      vi=true;;
    z)
      DOT_FILES=('.zshrc' "${DOT_FILES[@]}")
      zsh=true;;
  esac
done

for dotfile in "${DOT_FILES[@]}"
do
  if [ -e $HOME/$dotfile ]; then
    mv $HOME/$dotfile $HOME/$dotfile.old
  fi
  cp $dotfile $HOME
done

if [ $zsh ]; then
  if [ ! -e $CURRENT_DIR/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $CURRENT_DIR/zsh-syntax-highlighting
  fi

  if [ ! -e $CURRENT_DIR/zsh-interactive-cd ]; then
    git clone https://github.com/changyuheng/zsh-interactive-cd.git $CURRENT_DIR/zsh-interactive-cd
  fi

  echo "source $CURRENT_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $HOME/.zshrc
  echo "source $CURRENT_DIR/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh" >> $HOME/.zshrc
  echo "source $HOME/.fzf.zsh" >> $HOME/.zshrc
  # echo "source ~/.fzf/shell/key-bindings.zsh" >> $HOME/.zshrc
  source $HOME/.zshrc
fi

if [ $vi ]; then
  if [ ! -e $HOME/.vim/toml ]; then
    mkdir -p $HOME/.vim/toml
  fi
  cp -f $CURRENT_DIR/dein.toml $HOME/.vim/toml/
fi
