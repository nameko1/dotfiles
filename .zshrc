#
#~/.zshrc
#
#emacs likeな操作になる
bindkey -e

# export LANG=ja_JP.UTF-8
export LANG=en_US.UTF-8

export FZF_DEFAULT_OPTS='
--ansi --select-1 --reverse
--color fg:229,bg:236,hl:84,fg+:15,bg+:239,hl+:108
--color info:108,prompt:109,spinner:108,pointer:168,marker:168'

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
#clear-screenがconflictしたので^Oに変更
bindkey "^O" clear-screen
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
alias restart='exec $SHELL -l'

case ${OSTYPE} in
  darwin*)
    alias l='ls -G'
    alias ls='ls -G'
    alias ll='ls -lG'
    alias la='ls -aG'
    alias lla='ls -alG'
    alias vi='/usr/local/bin/vim'
    export EDITOR=/usr/local/bin/vim
    ;;
  linux*)
    alias l='ls --color'
    alias ls='ls --color'
    alias ll='ls -l --color'
    alias la='ls -a --color'
    alias lla='ls -al --color'
    alias vi='/usr/bin/vim'
    export EDITOR=/usr/bin/vim
    ;;
esac

#tmux x11 setting
echo $DISPLAY > ~/.display.txt
alias updis='export DISPLAY=`cat ~/.display.txt`'

# fzf script
# open vi
fe() {
  local file
  file=$(fzf --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

fl() {
  file=$(fzf --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && less "$file"
}

# cd
fd() {
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
    -o -type d -print 2> /dev/null | fzf +m) &&
    cd "$dir"
}

# find history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

fkill() {
  ps -ef | sed 1d | fzf -m | awk '{print $2}' | xargs kill -${1:-9} 
}

z() {
  if [[ -z "$*" ]]; then
    cd "$(_z -l 2>&1 | fzf +s --tac | sed 's/^[0-9,.]* *//')"
  else
    _last_z_args="$@"
    _z "$@"
  fi
}

zz() {
  cd "$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf -q "$_last_z_args")"
}

# fs [FUZZY PATTERN] - Select selected tmux session
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fs() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
    tmux switch-client -t "$session"
}
