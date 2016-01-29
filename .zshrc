#
#~/.zshrc
#

export LANG=ja_JP.UTF-8


#prompt
PROMPT='%n:%~$ '
PROMPT2="%_%% "
SPROMPT="%r is correct? [n,y,a,e]: "

#completion
autoload -U compinit
compinit
setopt correct

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

#alias
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi='/usr/local/bin/vim'
alias ls='ls -la'
alias gdb='gdb -q'
alias restart='exec $SHELL -l'
