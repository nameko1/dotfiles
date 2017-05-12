#!/bin/bash

DOT_FILES=()
CURRNT_DIR=$(cd $(dirname $0) && pwd)

# for file in ${DOTDOT_FILES[*]}
# do
#     if [ ! -s ~/$file ];then
#         cp $file ~/
#     fi
# done

# while getopts f: o; do
#     case $o in
#         f)
#             echo $OPTARG ;;
#         /?) exit 1;;
#     esac
# done

while getopts ptvz-: o; do
  case "$o" in
    -)
      case "${OPTARG}" in
        all)
          DOT_FILES=('.tmux.conf .vimrc .zshrc')
          plugin=true
          vi=true
          zsh=true;;
        vimplugin)
          plugin=true;;
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
    p)
      plugin=true;;
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

  if [ ! -e $CURRNT_DIR/fzf ]; then
    git clone https://github.com/junegunn/fzf.git $CURRNT_DIR/fzf
    $CURRNT_DIR/fzf/install --all
  else
    $CURRNT_DIR/fzf/install --no-key-bindings --no-completion --update-rc
  fi
  echo "source $CURRNT_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $HOME/.zshrc
  echo "source $CURRNT_DIR/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh" >> $HOME/.zshrc
fi

if [ $vi ]; then
  if [ -e $CURRNT_DIR/fzf ]; then
    echo "set rtp+=$CURRNT_DIR/fzf" >> $HOME/.vimrc
  fi
fi

if [ $plugin ];then
  if [ ! -e $HOME/.vim/bundle ]; then
    mkdir -p ~/.vim/bundle
  fi
  if [ ! -e $HOME/.vim/bundle/neobundle.vim ]; then
    git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
  else
    echo 'neobundle is already installed'
  fi

  if [ ! -e $HOME/.vim/autoload/ ]; then
    mkdir -p ~/.vim/autoload
  fi
  if [ ! -e $HOME/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
          https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  else
    echo 'vim-plug is already installed'
  fi
fi
