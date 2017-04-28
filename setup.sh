#!/bin/bash

# DOTFILES=('.vimrc' '.zshrc' '.zshenv' '.tmux')

# for file in ${DOTFILES[*]}
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

while [[ $# > 0 ]]; do
    case $1 in
        -b|--bundle) 
            bundle=true;;
        -t|--tmux)
            tmux=true;;
        -v| --vim)
            vimrc=true;;
        -z| --zsh)
            zsh=true;;
        *) echo "Unknown options:' $1"
    esac
    shift
done

if [ $tmux ];then
    mv $HOME/.tmux.conf $HOME/.tmux.conf.old
    cp .tmux.conf $HOME
fi

if [ $vimrc ];then
    mv $HOME/.vimrc $HOME/.vimrc
    cp .vimrc $HOME
fi

if [ $zsh ];then
    mv $HOME/.zshrc $HOME/.zshrc
    cp .zshrc $HOME
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
