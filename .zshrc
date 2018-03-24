#
#~/.zshrc
#
#emacs likeな操作になる
bindkey -e

# export LANG=ja_JP.UTF-8
export LANG=en_US.UTF-8

export FZF_DEFAULT_OPTS='
--height=40%
--ansi --exit-0 --reverse 
--color fg:229,bg:000,hl:84,fg+:15,bg+:239,hl+:108
--color info:108,prompt:109,spinner:108,pointer:168,marker:168'

export FZF_TMUX=1

#prompt
PROMPT='nameko:%~$ '
PROMPT2="%_%% "
RPROMPT=""
SPROMPT="%r is correct? [n,y,a,e]: "

#いい感じのコマンド補完
autoload -U compinit
compinit
setopt correct
setopt auto_list

#vcs_info loading
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

#zstyle ':vcs_info:*' formats '(%s) [%b]'
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' enable git hg bzr


function _update_vcs_info_msg() {
  local -a messages
  local prompt
  LANG=en_US.UTF-8 vcs_info

  if [[ -z ${vcs_info_msg_0_} ]]; then
    # vcs_info で何も取得していない場合はプロンプトを表示しない
    prompt=""
  else
    [[ -n "$vcs_info_msg_0_" ]] && messages+=( "%F{green}${vcs_info_msg_0_}%f" )
    prompt="${(j: :)messages}"
  fi

  RPROMPT="$prompt"
}
add-zsh-hook precmd _update_vcs_info_msg

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

# find history
zle     -N     fzf-history-widget
bindkey '^R' fzf-history-widget

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
alias vi='/usr/bin/vim'
export EDITOR=/usr/bin/vim

case ${OSTYPE} in
  darwin*)
    alias l='ls -G'
    alias ls='ls -G'
    alias ll='ls -lG'
    alias la='ls -aG'
    alias lla='ls -alG'
    ;;
  linux*)
    alias l='ls --color'
    alias ls='ls --color'
    alias ll='ls -l --color'
    alias la='ls -a --color'
    alias lla='ls -al --color'
    ;;
esac

#tmux x11 setting
echo $DISPLAY > ~/.display.txt
alias updis='export DISPLAY=`cat ~/.display.txt`'

# fzf script
# open vi
fe() {
  local file
  file=$(fzf-tmux --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

fl() {
  file=$(fzf-tmux --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && less "$file"
}

# cd
fd() {
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
    -o -type d -print 2> /dev/null | fzf-tmux +m --select-1 --query="'") &&
    cd "$dir"
}


fkill() {
  ps -ef | sed 1d | fzf-tmux -m | awk '{print $2}' | xargs kill -${1:-9} 
}

# z() {
#   if [[ -z "$*" ]]; then
#     cd "$(_z -l 2>&1 | fzf +s --tac | sed 's/^[0-9,.]* *//')"
#   else
#     _last_z_args="$@"
#     _z "$@"
#   fi
# }
#
# zz() {
#   cd "$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf -q "$_last_z_args")"
# }

# fs [FUZZY PATTERN] - Select selected tmux session
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fs() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
    tmux switch-client -t "$session"
}

fadd() {
  # valiables 
  local query addfiles fzfout filenum
  
  while fzfout=$(
    git status --short | 
    awk '{if (substr($0,2,1) !~ / /) print $2}' | fzf-tmux --multi --exit-0 --expect=ctrl-d); do
    query=$(head -1 <<< "$fzfout")
    filenum=$[$(wc -l <<< "$fzfout") - 1]
    addfiles=(`echo $(tail -n "$filenum" <<< "$fzfout")`)

    if [ "${query:-Enter}" = "ctrl-d" ]; then
      git diff --color=always $addfiles | less -R
    else
      git add $addfiles
      print "add this file(s) -> "$addfiles
    fi
  done
  }
