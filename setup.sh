#!/bin/zsh

DOT_FILES=()
CURRENT_DIR=$(cd $(dirname $0) && pwd)

DOT_FILES=('.tmux.conf' '.zshrc')

for dotfile in "${DOT_FILES[@]}"
do
  ln -sf $CURRENT_DIR/$dotfile $HOME/$dotfile
done

# zsh setting
if [ ! -e $HOME/.zshenv ]; then
  touch $HOME/.zshenv
fi

if [ ! -e ${HOME}/.zfunctions/prompt_pure_setup ];then
  mkdir -p ${HOME}/.zfunctions
  git clone https://github.com/sindresorhus/pure.git
  ln -s "${CURRENT_DIR}/pure/pure.zsh" "${HOME}/.zfunctions/prompt_pure_setup"
  ln -s "${CURRENT_DIR}/pure/async.zsh" "${HOME}/.zfunctions/async"
fi

if [ ! -e ${HOME}/.local/share/zinit ]; then
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
    #zcompile ${HOME}/.zinit/bin/zplugin.zsh
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

IS_CTAGS=`which ctags`
if [ -z $IS_AG ];then
  echo '''
  Please, Install ctags

  Ubuntu:
   apt install exuberant-ctags
  CentOS:
   yum install ctags
  '''
fi
