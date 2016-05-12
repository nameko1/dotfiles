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
alias -g xg='|grep -v build |xargs grep'
alias -g le='|less'
alias vi='/usr/bin/vim'
alias ll='ls -l'
alias la='ls -a'
alias restart='exec $SHELL -l'
alias ecl='eclipse -vmargs -XX:MaxPermSize=1G -Xmx1G > /dev/null 2>&1 &' 
alias sdb='psql -d synergy -U totalcontrol -h localhost -p 15432'
alias stdb='psql -d synergy_test -U totalcontrol -h localhost -p 15432'
alias client='/var/sites/w.crmstyle.com/tomcat/bin/catalina.sh start'
alias management='/var/sites/SynergyManagement/tomcat/bin/catalina.sh start'
alias move='/var/sites/k.msgs.jp/tomcat/bin/catalina.sh start'
alias operator='/var/sites/op.crmstyle.com/tomcat/bin/catalina.sh start'
alias cti='/var/sites/cti.crmstyle.com/tomcat/bin/catalina.sh start'
alias from='/var/sites/f.msgs.jp/tomcat/bin/catalina.sh start'

export NVM_DIR="/home/tanita.satoshi/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
