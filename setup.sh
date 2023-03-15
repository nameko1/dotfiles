#!/bin/zsh

DOT_FILES=()
CURRENT_DIR=$(cd $(dirname $0) && pwd)

DOT_FILES=('.tmux.conf' '.zshrc')

for dotfile in "${DOT_FILES[@]}"
do
  ln -sf $CURRENT_DIR/$dotfile $HOME/$dotfile
done

# vi setting
if [ ! -e $HOME/.vim ]; then
  cp -r vimrc/ $HOME/.vim
  # mkdir -p $HOME/.vim/rc
  # mkdir -p $HOME/.vim/autoload
fi
# ln -sf $CURRENT_DIR/vimrc/rc/dein.rc.vim $HOME/.vim/rc/dein.rc.vim
# ln -sf $CURRENT_DIR/vimrc/rc/dein.toml $HOME/.vim/rc/dein.toml
# ln -sf $CURRENT_DIR/vimrc/rc/dein_lazy.toml $HOME/.vim/rc/dein_lazy.toml
# ln -sf $CURRENT_DIR/vimrc/rc/init.rc.vim $HOME/.vim/rc/init.rc.vim
# ln -sf $CURRENT_DIR/vimrc/rc/mappings.rc.vim $HOME/.vim/rc/mappings.rc.vim
# ln -sf $CURRENT_DIR/vimrc/rc/options.rc.vim $HOME/.vim/rc/options.rc.vim
# ln -sf $CURRENT_DIR/vimrc/rc/rc.vim $HOME/.vim/rc/rc.vim
# ln -sf $CURRENT_DIR/vimrc/rc/statusline.rc.vim $HOME/.vim/rc/statusline.rc.vim
# ln -sf $CURRENT_DIR/vimrc/vimrc $HOME/.vim/vimrc
# ln -sf $CURRENT_DIR/vimrc/autoload/myfunc.vim $HOME/.vim/autoload/myfunc.vim

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

#vim lint
# pip install vim-vint
