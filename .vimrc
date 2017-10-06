filetype plugin indent off

"vim-plug
call plug#begin()
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
call plug#end()


"Neobundleでプラグイン管理
if has('vim_starting')
set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

"NeoBundleの初期化
call neobundle#begin()

"インストールするプラグイン
"ファイル開く奴
" NeoBundle 'Shougo/unite.vim'
" NeoBundle 'Shougo/neomru.vim'
" NeoBundle 'ujihisa/unite-colorscheme'
" 入力モードで開始
" let g:unite_enable_start_insert=1
" バッファ一覧
" nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" " ファイル一覧
" nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" " レジスタ一覧
" nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" " 最近使用したファイル一覧
" nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" " ファイルバッファ？
" nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
" " めちゃ便利
" nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
" " ウィンドウを分割して開く
" au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" " ウィンドウを縦に分割して開く
" au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" " ESC2回押すと終り
" au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
" au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q

NeoBundle 'scrooloose/nerdtree'
nnoremap <silent><C-e> :NERDTreeToggle<CR>
NeoBundle 'scrooloose/syntastic'

"コメントON/OFF
NeoBundle 'tomtom/tcomment_vim'

"colorchema
"molokai
NeoBundle 'tomasr/molokai'
"hybrid
NeoBundle 'w0ng/vim-hybrid'

call neobundle#end()

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
  autocmd CursorMoved,CursorMovedI * call <SID>Update()
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

function! s:FindCurrentWord()
  let l:currentWord = expand("<cword>")
  :echo l:currentWord
  call fzf#run(fzf#wrap({'sink': 'tabedit', 'options': '-m -q'.l:currentWord.get(g:, 'fzf_files_option', '')}))
endfunction

nnoremap <C-o> :call <SID>FindCurrentWord()

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
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%{b:charCounterCount}%8l,%c%V%8P"ステータス行の表示内容を設定する
set showcmd "入力中のステータスに表示する
set laststatus=2 "ステータスラインを表示するウィンドウを設定する "2:常にステータスラインを表示する
set listchars=tab:>- "listで表示される文字のフォーマットを指定する "※デフォルト eol=$ を打ち消す意味で設定

syntax on "シンタックスハイライト
"let g:hybrid_use_Xresources = 1 "hybridのおまじない
colorscheme hybrid "色設定ファイルの指定
set background=dark
set t_Co=256

"操作系
set backspace=indent,eol,start "バックスペースで各種消せます
set tabstop=8 "インデントをスペース4つ分に設定
set softtabstop=2 "tabでのスペースの数を設定
set shiftwidth=2 "自動インデントの各段階に使われる空白の数
set expandtab "<Tab>の制御に空白文字を用いる
set autoindent "新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする

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

nnoremap <C-p> :tabnew<Enter>

"fzf setting
nnoremap si :Files<Enter>
nnoremap so :Buffers<Enter>
nnoremap sp :Commands<Enter>

"検索設定
set ignorecase "大文字/小文字の区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る
set hlsearch "highlight matches with last search pattern

"検索時に検索単語を画面中央に
nnoremap n nzz
nnoremap N Nzz

"編集モードでのショートカット

"波括弧を自動補完
inoremap {<Enter> {}<Left><CR><Left><ESC><S-o><Left> 

"emacs like なショートカット
"map! <C-a> <home>
"map! <C-e> <end>
inoremap <C-a> <home>
inoremap <C-e> <end>

"編集モードでもコマンドモードな移動
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

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
inoremap <C-c> <ESC>:w<Enter>:SyntasticCheck<Enter>a
nnoremap <C-c> :w<Enter>:SyntasticCheck<Enter>


"syntastic setting
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=2
let g:syntastic_mode_map = {'mode': 'passive'}
let g:syntastic_python_checkers = ['pylint']

"OS setting
let OSTYPE = system('uname')
if OSTYPE == "Darwin\n"
    nnoremap g@ :!~/Documents/lab/Tex/tex_compile.sh %<Enter>
endif
