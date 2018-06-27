"*************************************
" Options
"*************************************
set encoding=utf-8 "デフォルトエンコをutf-8に設定
scriptencoding
filetype plugin indent off

" setting undo file
if has('persistent_undo')
  set undodir=/tmp
  set undofile
endif

" no backup files
set noswapfile
set nowritebackup
set nobackup

set history=10000

" search setting
set ignorecase
set smartcase
" search wrap around the end of the file
set wrapscan
"highlight matches with last search pattern
set hlsearch

" silent bell
set visualbell t_vb=
set novisualbell

" vitual setting
" show the cursor position
set ruler
set list
set title
" show line number
set number
set scrolloff=5
set matchpairs& matchpairs+=<:>
set showmatch
set listchars=tab:>-
set backspace=indent,eol,start
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent

let &tabline = '%!'.myfunc#SID_PREFIX().'myfunc#my_tabline()'

" color setting
highlight TrailingSpaces term=underline ctermbg=197
augroup MyHighlight
  autocmd!
  autocmd ColorScheme * highlight StatusLine ctermfg=242 ctermbg=17
  autocmd ColorScheme * highlight PWD ctermbg=242 ctermfg=189
  autocmd VimEnter,WinEnter,TabEnter,InsertLeave * match TrailingSpaces /[　 ]\+$/
augroup END

colorscheme hybrid
set background=dark
set t_Co=256

augroup EditVimrcSetting
  autocmd!
  autocmd FileType vim
        \ setlocal tabstop=2 softtabstop=2 shiftwidth=2
  autocmd FileType vim nnoremap ss :source %<CR>
augroup END

set tags=.tags;$HOME
command! UpdateTags :call myfunc#update_ctags()

" 文字コード変更
command! -bang -nargs=? Utf8
      \ edit<bang> ++enc=utf-8 <args>

command! -bang -nargs=? Sjis
      \ edit<bang> ++enc=sjis <args>

command! -bang -nargs=? Eucjp
      \ edit<bang> ++enc=euc-jp <args>

" file format変更
command! -bang -nargs=? Unix
      \ edit<bang> ++ff=unix <args>

command! EditMacro :call myfunc#EditMacro()
