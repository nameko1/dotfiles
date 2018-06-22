set encoding=utf-8 "デフォルトエンコをutf-8に設定
scriptencoding
filetype plugin indent off

let s:dein_dir = expand('~/.vim/dein')
let s:dein = s:dein_dir . '/dein.vim'

"tomlファイルの場所
let s:toml_dir = expand('~/.vim/toml')
let s:toml = s:toml_dir . '/dein.toml'

"Deinがなければインストールする
if has('vim_starting')
  if !isdirectory(s:dein_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein
  endif
  set runtimepath+=~/.vim/dein/dein.vim/
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  "設定ファイルの読み込み
  call dein#load_toml(s:toml)

  "設定終わり
  call dein#end()
  call dein#save_state()
endif

"未インストールがあればいれる
if dein#check_install()
  call dein#install()
endif

filetype plugin indent on

"undo
if has('persistent_undo')
  set undodir=/tmp
  set undofile
endif

"文字数カウント関数
" augroup CharCounter
"   autocmd!
"   " autocmd BufNew,BufEnter,BufWrite,InsertLeave * call <SID>Update()
"   autocmd BufEnter,CursorMoved,CursorMovedI * call <SID>Update()
" augroup END

function! s:Update()
  let b:charCounterCount = s:VisualCharCount()
endfunction

function! s:VisualCharCount()
  let l:result = 0
  for l:linenum in range(line('v'), line('.'))
    let l:line = getline(l:linenum)
    let l:result += strlen(substitute(l:line, '.', 'x', 'g'))
  endfor
  return l:result
endfunction

"カーソル下の単語のつくファイルを検索するコマンド
function! s:FindCurrentWord()
  let l:currentWord = expand('<cword>')
  call fzf#run(fzf#wrap({'options': '-m -q'.l:currentWord.get(g:, 'fzf_files_option', '')}))
endfunction

" マクロを編集するスクリプト
function! s:EditMacro()
  let l:char = input("Which macro want to edit?\n")
  if strlen(matchstr(l:char, '^[a-z]$')) == 1
    let l:omacro = getreg(l:char, 0)
    let l:nmacro = input("\nEdit macro yourself\n", l:omacro)
    :call setreg(l:char, l:nmacro)
  en
endfunction
command! EditMacro :call <SID>EditMacro()

function! s:GetAllTabBuf()
  let l:buflist =  []
  for l:tabnum in range(tabpagenr('$'))
    let l:header = l:tabnum + 1.' '
    if l:tabnum < 9
      let l:header = ' '.l:header
    endif
    let l:bufnames =' '
    for l:buf in tabpagebuflist(l:tabnum + 1)
      let l:bufnames .= fnamemodify(bufname(l:buf), ':t').', '
    endfor
    call add(l:buflist, l:header.substitute(l:bufnames, ', $', '', ''))
  endfor
  return l:buflist
endfunction

function! s:FindTab()
  let l:result = fzf#run({'source': s:GetAllTabBuf(), 'down': '40%'})
  if len(l:result) == 0
    return
  endif
  call s:MoveTab(substitute(matchstr(l:result[0], '^\s\?[0-9]\+'), '^\s', '',''))
endfunction

function! s:MoveTab(num)
  let l:currentTab = tabpagenr()
  let l:loop = a:num - l:currentTab
  if a:num <= l:currentTab
    let l:loop = tabpagenr('$') + l:loop
  endif
  for l:l in range(l:loop)
    tabnext
  endfor
endfunction

function! s:Lines(...)
  let [l:display_bufnames, l:lines] = fzf#vim#_lines(1)
  let l:nth = l:display_bufnames ? 3 : 2
  let [l:query, l:args] = (a:0 && type(a:1) == type('')) ?
        \ [a:1, a:000[1:]] : ['', a:000]
  let l:query = '--query '.shellescape(l:query)

  let l:selectedbuf = fzf#run({
  \ 'source':  l:lines,
  \ 'down': '40%',
  \ 'options': '+m --tiebreak=index --prompt "Lines> " --ansi --extended --nth='.l:nth.'.. --reverse --tabstop=1 '.l:query
  \})

  if len(l:selectedbuf) == 0
    return
  endif

  let l:lines = split(l:selectedbuf[0], '\s\+')
  let l:tabpage = 0

  for l:tabnum in range(tabpagenr('$'))
    for l:tabbuf in tabpagebuflist(l:tabnum + 1)
      if l:tabbuf == l:lines[0]
        let l:tabpage = l:tabnum + 1
      endif
    endfor
  endfor

  if l:tabpage != 0
    call s:MoveTab(l:tabpage)
  else
    execute 'silent tab split'
    execute 'buffer' l:lines[0]
  endif

  execute l:lines[2]
  normal! ^zz

endfunction

"環境設定
set noswapfile "swapfileを作らない
set nowritebackup "backupfileを作らない
set nobackup "バックアップしない
set history=10000 "コマンド、検索パターンを記憶しておく

"ビープ音を消す
set visualbell t_vb=
set novisualbell

"見た目系
set ruler  "カーソルが何行目の何列目に置かれているかを表示する
set list "不可視文字を表示
set title "編集中のファイル名を表示
set number "行番号を表示
set scrolloff=5 "スクロールする際に下が見えるように
set matchpairs& matchpairs+=<:> "対応括弧に<>を追加
set showmatch "括弧入力時の対応する括弧を表示
set statusline=%{NCwin(currentWin)}%#PWD#%{Cwin(currentWin)}%## "current dirを表示
set statusline+=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'} "ステータスライン左側
" set statusline+=%=[wc=%{b:charCounterCount}]%8l,%c%V%8P "ステータスライン右側
set statusline+=%=%{AleCount()}%8l,%c%V%6P "ステータスライン右側
set showcmd "入力中のステータスに表示する
set laststatus=2 "ステータスラインを表示するウィンドウを設定する "2:常にステータスラインを表示する
set listchars=tab:>- "listで表示される文字のフォーマットを指定する "※デフォルト eol=$ を打ち消す意味で設定

function! Cwin(currentWin)
  return a:currentWin==winnr()?
        \substitute(getcwd(), $HOME, '~', '').'/':''
endfunction
function! NCwin(currentWin)
  return a:currentWin==winnr()?
        \'':substitute(getcwd(), $HOME, '~', '').'/'
endfunction

function! AleCount()
  let l:output=''
  let l:ale=ale#statusline#Count(bufnr('%'))
  if 0!=l:ale['error']
    let l:output=l:output.l:ale['error'].' errors'
  endif
  if 0!=l:ale['warning']
    let l:output=l:output.l:ale['warning'].' warings'
  endif
  return l:output
endfunction

augroup HighlightStatusLine
  autocmd!
  autocmd ColorScheme * highlight StatusLine ctermfg=242 ctermbg=17
  autocmd ColorScheme * highlight PWD ctermbg=242 ctermfg=189
augroup END

augroup CurrentWin
  autocmd!
  autocmd VimEnter,TabEnter,WinEnter * let currentWin=tabpagewinnr(tabpagenr())
augroup END

augroup HighlightSpace
  autocmd!
  autocmd VimEnter,WinEnter,TabEnter * highlight TrailingSpaces term=underline ctermbg=197
  autocmd VimEnter,WinEnter,TabEnter,InsertLeave * match TrailingSpaces /[　 ]\+$/
augroup END

" tab番号を表示する
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'),'<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()
  let l:tabtitle = ''
  for l:tabnum in range(1, tabpagenr('$'))
    let l:bufnrs = tabpagebuflist(l:tabnum)
    let l:bufnr = l:bufnrs[tabpagewinnr(l:tabnum) - 1]  " first window, first appears
    let l:no = l:tabnum  " display 0-origin tabpagenr.
    let l:mod = getbufvar(l:bufnr, '&modified') ? '!' : ' '
    let l:title = fnamemodify(bufname(l:bufnr), ':t')
    let l:tabtitle .= '%'.l:tabnum.'T'
    let l:tabtitle .= '%#'.(l:tabnum == tabpagenr() ? 'TabLineSel' : 'TabLine').'#'
    let l:tabtitle .= l:no .':'.l:title
    let l:tabtitle .= l:mod
    let l:tabtitle .= '%#TabLineFill# '
  endfor
  let l:tabtitle .= '%#TabLineFill#%T%=%#TabLine#'
  return l:tabtitle
endfunction

let &tabline = '%!'.s:SID_PREFIX().'my_tabline()'

syntax on "シンタックスハイライト
"let g:hybrid_use_Xresources = 1 "hybridのおまじない
colorscheme hybrid "色設定ファイルの指定
set background=dark
set t_Co=256

"操作系
set backspace=indent,eol,start "バックスペースで各種消せます
set tabstop=4 "インデントをスペース2つ分に設定
set softtabstop=4 "tabでのスペースの数を設定
set shiftwidth=4 "自動インデントの各段階に使われる空白の数
set expandtab "<Tab>の制御に空白文字を用いる
set autoindent "新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする

augroup EditVimrcSetting
  autocmd!
  autocmd FileType vim
        \ setlocal tabstop=2 softtabstop=2 shiftwidth=2
  autocmd FileType vim nnoremap ss :source %<CR>
augroup END

augroup OmniCompletion
  autocmd!
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
augroup END

" 辞書設定
let g:neocomplete#source#dictionary#dictionares = {
      \ 'default': '',
      \ 'php': ''
      \}

"マルチ画面
"s + hjkl で画面移動
nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l

"Ctrl + hjklでウィンドウサイズ変更
nnoremap <C-h> <C-w><
nnoremap <C-l> <C-w>>
nnoremap <C-k> <C-w>-
nnoremap <C-j> <C-w>+

"command line高速化！
nnoremap : ;
nnoremap ; :

"open new tab
nnoremap to :tabnew<Enter>
"close current tab
nnoremap te :tabclose<Enter> gT
"move next tab
nnoremap tn :tabnext<Enter>
"move previous tab
nnoremap tp :tabprevious<Enter>

" quick fix cn cp
nnoremap <C-n> :cnext<CR>
nnoremap <C-p> :cprevious<CR>

" key bind <Space>
nnoremap <Space>a :tabnew<CR>:Ack<Space>
nnoremap <Space>b :Buffers<CR>
nnoremap <Space>c :Commands<CR>

nnoremap <Space>f :Files<CR>

nnoremap <Space>h :Helptags<CR>

nnoremap <Space>m :marks<CR>

" カーソル下のワードをファイル名に含むファイルを検索
nnoremap <Space>o :call <SID>FindCurrentWord()<CR>

nnoremap <Space>q :q<CR>
nnoremap <Space>r :registers<CR>

nnoremap <Space>s :sh<CR>
nnoremap <Space>t :call <SID>FindTab()<CR>

nnoremap <Space>w :w<CR>
nnoremap <Space>wq :wq<CR>

" " fzf tab
" nnoremap st :call <SID>FindTab()<Enter>

" fzf line
command! -nargs=1 L call <SID>Lines(<f-args>)
nnoremap sr :call <SID>Lines()<Enter>


"検索設定
set ignorecase "大文字/小文字の区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る
set hlsearch "highlight matches with last search pattern

"検索時に検索単語を画面中央に
nnoremap n nzz
nnoremap N Nzz

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

imap <C-i>     <Plug>(neosnippet_expand_or_jump)
smap <C-i>     <Plug>(neosnippet_expand_or_jump)
xmap <C-i>     <Plug>(neosnippet_expand_target)

"編集モードでのショートカット
"波括弧を自動補完
inoremap {<Enter> {}<Left><CR><Left><ESC><S-o><Left>

"emacs like なショートカット
inoremap <C-a> <home>
inoremap <C-e> <end>

"編集モードでもコマンドモードな移動
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

"command lineでのコマンドモードな移動
cnoremap <C-a> <home>
cnoremap <C-e> <end>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>

"cntl-d で一文字削除
inoremap <C-d> <delete>
"Enter で空白行を挿入
nnoremap <CR> :<C-u>call append(expand('.'), '')<CR>j

"OS setting
let g:OSTYPE = system('uname')
if g:OSTYPE ==# "Darwin\n"
  nnoremap g@ :!~/Documents/lab/Tex/tex_compile.sh %<Enter>
endif
