"*************************************
" Options
"*************************************
set encoding=utf-8
scriptencoding

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
set ignorecase                      " no distinguish lowercase and uppercase when search
set smartcase                       " if search word contain uppercase, serve as noignorecase
set wrapscan                        " search wrap around the end of the file
set hlsearch                        " highlight matches with last search pattern

" silent bell
set visualbell t_vb=
set novisualbell

" vitual setting
set ruler                           " show the cursor position
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
set expandtab                       " insert some space (set softtabstop) when enter <Tab>
set autoindent                      " automation indent
set autowrite                       " autowrite when open other file

let &tabline = '%!'.myfunc#SID_PREFIX().'myfunc#my_tabline()'

" color setting
colorscheme hybrid
set background=dark
set t_Co=256

highlight TrailingSpaces term=underline ctermbg=197
augroup MyHighlight
  autocmd!
  autocmd ColorScheme * highlight StatusLine ctermfg=242 ctermbg=17
  autocmd ColorScheme * highlight PWD ctermbg=242 ctermfg=189
  autocmd VimEnter,WinEnter,TabEnter,InsertLeave * match TrailingSpaces /[　 ]\+$/
augroup END

augroup EditSetting
  autocmd!
  autocmd FileType vim
        \ setlocal tabstop=2 softtabstop=2 shiftwidth=2
  autocmd FileType vim nnoremap ss :source %<CR>
  autocmd FileType zsh
        \ setlocal tabstop=2 softtabstop=2 shiftwidth=2
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
