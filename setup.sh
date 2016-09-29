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
    cp .tmux.conf ~/
fi

if [ $vimrc ];then
    cp .vimrc ~/
fi

if [ $zsh ];then
    cp .zshrc .zshenv ~/
fi

if [ $bundle ];then
    mkdir -p ~/.vim/bundle
    git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
fi
