#
#~/.zshrc
#
#emacs likeな操作になる
bindkey -e

# export LANG=ja_JP.UTF-8
export LANG=en_US.UTF-8
#環境に合わせて変えて
export EDITOR=/usr/bin/vim


#prompt
PROMPT='%m:%~$ '
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
setopt hist_ignore_all_dups
setopt hist_no_store
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

#vi like な移動設定
bindkey "^H" backward-char
bindkey "^L" forward-char
#clear-screenがconflictしたので^Iに変更
bindkey "^I" clear-screen
#単語移動設定
bindkey "^B" backward-word
bindkey "^W" forward-word

#alias
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias grep='grep --color'
alias -g gr='|grep --color'
alias -g le='|less'
alias -g xg='|xargs grep --color'
# alias vi='/usr/local/bin/vim'
alias vi='/usr/bin/vim'
alias l='ls --color'
alias ls='ls --color'
alias ll='ls -l --color'
alias la='ls -a --color'
alias restart='exec $SHELL -l'

#tmux x11 setting
echo $DISPLAY > ~/.display.txt
alias updis='export DISPLAY=`cat ~/.display.txt`'
