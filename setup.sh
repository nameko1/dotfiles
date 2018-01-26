#!/bin/bash

DOT_FILES=()
CURRNT_DIR=$(cd $(dirname $0) && pwd)

while getopts ptvz-: o; do
  case "$o" in
    -)
      case "${OPTARG}" in
        all)
          DOT_FILES=('.tmux.conf .vimrc .zshrc')
          vi=true
          zsh=true;;
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
  mv $HOME/$dotfile $HOME/$dotfile.old
  cp $dotfile $HOME
done

if [ $zsh ]; then
  if [ ! -e $CURRNT_DIR/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $CURRNT_DIR/zsh-syntax-highlighting
  fi

  if [ ! -e $CURRNT_DIR/zsh-interactive-cd ]; then
    git clone https://github.com/changyuheng/zsh-interactive-cd.git $CURRNT_DIR/zsh-interactive-cd
  fi

  echo "source $CURRNT_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $HOME/.zshrc
  echo "source $CURRNT_DIR/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh" >> $HOME/.zshrc
  echo "source ~/.fzf.zsh" >> $HOME/.zshrc
  # echo "source ~/.fzf/shell/key-bindings.zsh" >> $HOME/.zshrc
fi

if [ $vi ]; then
  if [ ! -e $HOME/.vim/toml ]; then
    mkdir -p ~/.vim/toml
  fi
  cp -f ./dein.toml $HOME/.vim/toml/
fi
