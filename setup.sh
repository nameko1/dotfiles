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
  # mkdir -p $HOME/.vim/dicts
  # mkdir -p $HOME/.vim/plugin
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
# ln -sf $CURRENT_DIR/vimrc/plugin/neocomplete.rc.vim $HOME/.vim/plugin/neocomplete.rc.vim
# ln -sf $CURRENT_DIR/vimrc/dicts/tex.dict $HOME/.vim/dicts/tex.dict

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

if [ ! -e ${HOME}/.zinit ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"
    zcompile ${HOME}/.zinit/bin/zplugin.zsh
fi

# if [ ! -e ${HOME}/.sshrc.d ];then
#     mkdir -p ${HOME}/.sshrc.d
#     ln -sf $CURRENT_DIR/vimrc/rc/ $HOME/.vim/rc
#     ln -sf $CURRENT_DIR/vimrc/vimrc $HOME/.vim/vimrc
#     ln -sf $CURRENT_DIR/vimrc/autoload/ $HOME/.vim/autoload
#     ln -sf $CURRENT_DIR/vimrc/plugin/ $HOME/.vim/plugin
#     ln -sf $CURRENT_DIR/vimrc/dicts/ $HOME/.vim/dicts
# fi

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
