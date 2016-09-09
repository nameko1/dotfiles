#
#~/.zshrc
#
#emacs likeな操作になる
bindkey -e

export LANG=ja_JP.UTF-8


#prompt
PROMPT='%n:%~$ '
PROMPT2="%_%% "
SPROMPT="%r is correct? [n,y,a,e]: "

#いい感じのコマンド補完
autoload -U compinit
compinit
setopt correct
setopt auto_list

#auto cd
#autoload auto_cd

#alias ...='cd ../..'
#alias ....='cd ../../..'

#histoy
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt share_history
setopt auto_pushd
setopt pushd_ignore_dups
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
function history-all { history -E 1 }

#alias
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias -g gr='|grep'
alias -g le='|less'
alias -g xg='|xargs grep'
alias vi='/usr/local/bin/vim'
alias ll='ls -l'
alias la='ls -a'
alias restart='exec $SHELL -l'

#tmux x11 setting
echo $DISPLAY > ~/.display.txt
alias updis='export DISPLAY=`cat ~/.display.txt`'
