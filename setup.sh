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

while getopts btvz-: o; do
  case "$o" in
    -)
      case "${OPTARG}" in
        all)
          DOT_FILES=('.tmux.conf .vimrc .zshrc')
          bundle=true
          zsh=true;;
        bundle)
          bundle=true;;
        tmux)
          DOT_FILES=('.tmux.conf' "${DOT_FILES[@]}")
          ;;
        vim)
          DOT_FILES=('.vimrc' "${DOT_FILES[@]}")
          ;;
        zsh)
          DOT_FILES=('.zshrc' "${DOT_FILES[@]}")
          zsh=true;;
      esac;;
    b)
      bundle=true;;
    t)
      DOT_FILES=('.tmux.conf' "${DOT_FILES[@]}")
      ;;
    v)
      DOT_FILES=('.vimrc' "${DOT_FILES[@]}")
      ;;
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
  git clone git://github.com/zsh-users/zsh-syntax-highlighting.git $CURRNT_DIR/zsh-syntax-highlighting
  fi
  echo "source $CURRNT_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $HOME/.zshrc 
fi

if [ $bundle ];then
  if [ ! -e $HOME/.vim/bundle ]; then
    mkdir -p ~/.vim/bundle
  fi
  if [ ! -e $HOME/.vim/bundle/neobundle.vim ]; then
    git clone git://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
  else
    echo 'neobundle is already installed'
  fi
fi
