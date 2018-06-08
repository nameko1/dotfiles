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
augroup CharCounter
  autocmd!
  " autocmd BufNew,BufEnter,BufWrite,InsertLeave * call <SID>Update()
  autocmd BufEnter,CursorMoved,CursorMovedI * call <SID>Update()
augroup END

function! s:Update()
  let b:charCounterCount = s:VisualCharCount()
endfunction

function! s:VisualCharCount()
  let l:result = 0
  for l:linenum in range(line('v'), line('.'))
    let l:line = getline(l:linenum)
    let l:result += strlen(substitute(l:line, ".", "x", "g"))
  endfor
  return l:result
endfunction

"カーソル下の単語のつくファイルを検索するコマンド
function! s:FindCurrentWord()
  let l:currentWord = expand("<cword>")
  call fzf#run(fzf#wrap({'options': '-m -q'.l:currentWord.get(g:, 'fzf_files_option', '')}))
endfunction

"文書検索するスクリプト
function! s:FindText(...)
  let l:query = "'".join(a:000, ' ')."'"

  let l:selectedbufs =  fzf#run({
        \ 'source': 'find . -type f | xargs grep '.l:query,
        \ 'down': '40%',
        \ 'options': '-m --tiebreak=index --prompt "TextMatch> " --ansi --extended  --reverse --tabstop=1 --query '.l:query
        \ })
  if len(l:selectedbufs) == 0
    return
  endif
  
  let l:files = []
  for buf in l:selectedbufs
    call add(l:files, split(buf, ':')[0])
  endfor
  call uniq(l:files)

  for file in l:files
    execute 'tabnew'
    execute 'edit '.file
  endfor
endfunction
command! -nargs=+ FindText :call <SID>FindText(<f-args>)

" マクロを編集するスクリプト
function! s:EditMacro()
  let l:char = input("Which macro want to edit?\n")
  if strlen(matchstr(l:char, "^[a-z]$")) == 1
    let l:omacro = getreg(l:char, 0)
    let l:nmacro = input("\nEdit macro yourself\n", l:omacro)
    :call setreg(l:char, l:nmacro)
  en
endfunction
command! EditMacro :call <SID>EditMacro()

function! s:GetAllTabBuf()
  let l:buflist =  []
  for i in range(tabpagenr('$'))
    let l:header = i + 1." "
    if i < 9
      let l:header = " ".l:header
    endif
    let l:bufnames = " "
    for buf in tabpagebuflist(i + 1)
      let l:bufnames .= fnamemodify(bufname(buf), ":t").", "
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
  for l in range(l:loop)
    tabnext
  endfor
endfunction

function! s:Lines(...)
  let [display_bufnames, lines] = fzf#vim#_lines(1)
  let nth = display_bufnames ? 3 : 2
  let [query, args] = (a:0 && type(a:1) == type('')) ?
        \ [a:1, a:000[1:]] : ['', a:000]
  let query = '--query '.shellescape(query)

  let selectedbuf = fzf#run({
  \ 'source':  lines,
  \ 'down': '40%',
  \ 'options': '+m --tiebreak=index --prompt "Lines> " --ansi --extended --nth='.nth.'.. --reverse --tabstop=1 '.query
  \})

  if len(selectedbuf) == 0
    return
  endif

  let lines = split(selectedbuf[0], '\s\+')
  let tabpage = 0

  for i in range(tabpagenr('$'))
    for tabbuf in tabpagebuflist(i + 1)
      if tabbuf == lines[0]
        let tabpage = i + 1
      endif
    endfor
  endfor

  if tabpage != 0
    call s:MoveTab(tabpage)
  else
    execute 'silent tab split' 
    execute 'buffer' lines[0]
  endif

  execute lines[2]
  normal! ^zz

endfunction



"環境設定
set encoding=utf-8 "デフォルトエンコをutf-8に設定
set noswapfile "swapfileを作らない
set nowritebackup "backupfileを作らない
set nobackup "バックアップしない
set history=10000 "コマンド、検索パターンを記憶しておく

"ビープ音を消す
set vb t_vb=
set novisualbell

"見た目系
set ruler  "カーソルが何行目の何列目に置かれているかを表示する
set list "不可視文字を表示
set title "編集中のファイル名を表示
set number "行番号を表示
set scrolloff=5 "スクロールする際に下が見えるように
set matchpairs& matchpairs+=<:> "対応括弧に<>を追加
set showmatch "括弧入力時の対応する括弧を表示
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'} "ステータスライン左側
set statusline+=%=[wc=%{b:charCounterCount}]%8l,%c%V%8P "ステータスライン右側
" set statusline+=%=%8l,%c%V%8P "ステータスライン右側
set showcmd "入力中のステータスに表示する
set laststatus=2 "ステータスラインを表示するウィンドウを設定する "2:常にステータスラインを表示する
set listchars=tab:>- "listで表示される文字のフォーマットを指定する "※デフォルト eol=$ を打ち消す意味で設定

" tab番号を表示する
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'),'<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let s .= '%'.i.'T'
    let s .= '%#'.(i == tabpagenr() ? 'TabLineSel' : 'TabLine').'#'
    let s .= no .':'.title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}

let &tabline = '%!'.s:SID_PREFIX().'my_tabline()'



syntax on "シンタックスハイライト
"let g:hybrid_use_Xresources = 1 "hybridのおまじない
colorscheme hybrid "色設定ファイルの指定
set background=dark
set t_Co=256

"操作系
set backspace=indent,eol,start "バックスペースで各種消せます
set tabstop=2 "インデントをスペース2つ分に設定
set softtabstop=2 "tabでのスペースの数を設定
set shiftwidth=2 "自動インデントの各段階に使われる空白の数
set expandtab "<Tab>の制御に空白文字を用いる
set autoindent "新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする

augroup IndentSetting
  autocmd!
  autocmd FileType java 
        \setlocal shiftwidth=4 softtabstop=4 tabstop=4
  autocmd FileType python
        \setlocal shiftwidth=4 softtabstop=4 tabstop=4
augroup END

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

"mark, register参照
nnoremap <Space>r :registers<Enter>
nnoremap <Space>m :marks<Enter>

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

"fzf setting
nnoremap si :Files<Enter>
nnoremap so :Buffers<Enter>
nnoremap sp :Commands<Enter>

" fzf tab
nnoremap st :call <SID>FindTab()<Enter>

" fzf line
command! -nargs=1 L call <SID>Lines(<f-args>)
nnoremap sr :call <SID>Lines()<Enter>

" カーソル下のワードをファイル名に含むファイルを検索
nnoremap <C-o> :call <SID>FindCurrentWord()<Enter>

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

"cntl-r で行削除
inoremap <C-r> <ESC>0d$i<Left> 
"cntl-u でredo
inoremap <C-u> <ESC>ui
"cntl-d で一文字削除
inoremap <C-d> <delete>
"cntl-y でヤンク
inoremap <C-y> <ESC>pi 
"O で空白行を挿入
nnoremap O :<C-u>call append(expand('.'), '')<Cr>j

"Syntax Check
" inoremap <C-c> <ESC>:w<Enter>:SyntasticCheck<Enter>a
" nnoremap <C-c> :w<Enter>:SyntasticCheck<Enter>

"syntastic setting
" let g:syntastic_enable_signs=1
" let g:syntastic_auto_loc_list=2
" let g:syntastic_mode_map = {'mode': 'passive'}
" let g:syntastic_python_checkers = ['pylint']
"
"OS setting
let OSTYPE = system('uname')
if OSTYPE == "Darwin\n"
  nnoremap g@ :!~/Documents/lab/Tex/tex_compile.sh %<Enter>
endif

