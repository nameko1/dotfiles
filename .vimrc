filetype plugin indent off


"Neobundleでプラグイン管理
if has('vim_starting')
set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

"NeoBundleの初期化
call neobundle#begin()

"インストールするプラグイン
"ファイル開く奴
" NeoBundle 'Shougo/unite.vim'
" NeoBundle 'ujihisa/unite-colorscheme'

"コメントON/OFF
NeoBundle 'tomtom/tcomment_vim'

"colorchema
"molokai
NeoBundle 'tomasr/molokai'
"hybrid
NeoBundle 'w0ng/vim-hybrid'

call neobundle#end()

filetype plugin indent on

"環境設定

set encoding=utf-8 "デフォルトエンコをutf-8に設定
set noswapfile "swapfileを作らない
set nowritebackup "backupfileを作らない
set backup "バックアップしない
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
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P "ステータス行の表示内容を設定する
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
set softtabstop=4 "tabでのスペースの数を設定
set shiftwidth=4 "自動インデントの各段階に使われる空白の数
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

"検索設定
set ignorecase "大文字/小文字の区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る
set hlsearch "highlight matches with last search pattern
"検索時に検索単語を画面中央に
nnoremap n nzz
nnoremap N Nzz

"ショートカット

"波括弧を自動補完
inoremap {<Enter> {}<Left><CR><Left><ESC><S-o> 

"emacs like なショートカット
map! <C-a> <home>
map! <C-e> <end>
nnoremap <C-a> <home>
nnoremap <C-e> <end>

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
