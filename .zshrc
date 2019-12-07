#
#~/.zshrc
#
#emacs likeな操作になる
bindkey -e

fpath=("$HOME/.zfunctions" $fpath)

# zplugin
source "${HOME}/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin

if [[ "${+_comps}" == 1 ]];then
  _comps[zplugin] = _zplugin
fi

# export LANG=ja_JP.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export FZF_DEFAULT_OPTS='
--height=40%
--ansi --exit-0 --reverse
--color fg:229,bg:000,hl:84,fg+:15,bg+:239,hl+:108
--color info:108,prompt:109,spinner:108,pointer:168,marker:168
'

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l'

export FZF_TMUX=1
export LESSCHARSET=utf-8

#prompt
# PROMPT='nameko:%~$ '
if [[ -n $VIMRUNTIME  ]];then
    RPROMPT='%F{red}vimshell'
fi
PROMPT2="%_%% "
SPROMPT="%r is correct? [n,y,a,e]: "

#いい感じのコマンド補完
autoload -U compinit
compinit
setopt correct
setopt auto_list

# cd
setopt AUTO_PUSHD
setopt autocd

zstyle ':completion:*' menu select
zstyle ':completion:*:cd:*' ignore-parents parent pwd

#vcs_info loading
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

# zstyle ':vcs_info:*' formats '[%b]'
# zstyle ':vcs_info:*' enable git hg bzr
#
autoload -U promptinit; promptinit
prompt pure

#histoy
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_all_dups
setopt hist_no_store
setopt hist_ignore_dups
setopt hist_ignore_space
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
zle     -N   fzf-history-widget
bindkey '^R' fzf-history-widget

#vi like な移動設定
bindkey "^H" backward-char
bindkey "^L" forward-char
#clear-screenがconflictしたので^Oに変更
bindkey "^O" clear-screen
#単語移動設定
bindkey "^B" backward-word
bindkey "^W" forward-word
#単語除削設定
bindkey "^F" kill-word

#alias
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias grep='grep --color'
alias -g gr='|grep --color'
alias -g le='|less'
alias -g xg='|xargs grep --color'
alias restart='exec $SHELL -l'
# alias ssh='sshrc'

# alias vi='/usr/bin/vim'
# export EDITOR=/usr/bin/vim

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
  file=$(find ${1:-*} -path '*/\.*' -prune \
    -o -type f -print 2> /dev/null | fzf-tmux +m --query="$1" --select-1 --exit-0) &&
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

fl() {
  file=$(find ${1:-*} -path '*/\.*' -prune \
    -o -type f -print 2> /dev/null | fzf-tmux +m --query="$1" --select-1 --exit-0) &&
  [ -n "$file" ] && less "$file"
}

# cd
fd() {
  _fd_with_find $1
}

_fd_with_find() {
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
    -o -type d -print 2> /dev/null | fzf-tmux +m --select-1 --query="'") &&
    cd "$dir"
}

fkill() {
  ps -ef | sed 1d | fzf-tmux -m | awk '{print $2}' | xargs kill -${1:-9}
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

fch() {
  local branch
  branch=$(git branch --format='%(refname)' | cut -d / -f 3- | fzf-tmux --multi --exit-0)
  git checkout ${branch}
}

# d() {
#   local dir num
#   num=$(dirs -v | fzf-tmux +m --exit-0 | cut -f1)
#   echo $num
#   if [ $num -n ];then
#     return
#   fi
#   dir=$(dirs -vl | grep -e ^$num | cut -f2)
#   cd "$dir"
# }

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

zplugin light "zsh-users/zsh-syntax-highlighting"
zplugin light "changyuheng/zsh-interactive-cd"
zplugin snippet --command \
  'https://raw.githubusercontent.com/Russell91/sshrc/master/sshrc'
# zplugin ice as"program" from"gh-r" id-as"fzf"
# zplugin load "junegunn/fzf-bin"
source ~/.fzf.zsh

# export PYENV_ROOT="$HOME/.pyenv"
# eval "$(pyenv init -)"
