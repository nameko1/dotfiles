"*************************************
" KeyMappings
"*************************************

" normal mode keymapping
" insert blank line with enter
nnoremap <silent><CR> :<C-u>call append(expand('.'), '')<CR>j

" search word bring center
nnoremap n nzz
nnoremap N Nzz

" add/delete indent
nnoremap < <<
nnoremap > >>

" for move among pane
" move to left pane
nnoremap sh <C-w>h
" move to under pane
nnoremap sj <C-w>j
" move to over pane
nnoremap sk <C-w>k
" move to right
nnoremap sl <C-w>l

" change window size
" <C-h> horizontal reduce
nnoremap <C-h> <C-w><
" <C-l> horizontal expand
nnoremap <C-l> <C-w>>
" <C-k> vertical reduce
nnoremap <C-k> <C-w>-
" <C-j> vertical expand
nnoremap <C-j> <C-w>+


" change commnad line insert key
nnoremap : ;
nnoremap ; :

"open new tab
nnoremap <silent>to :tabnew<CR>
"close current tab
nnoremap <silent>te :tabclose<CR> gT
"move next tab
nnoremap <silent>tl :tabnext<CR>
"move previous tab
nnoremap <silent>th :tabprevious<CR>

" quick fix cn cp
nnoremap <C-n> :cnext<CR>
nnoremap <C-p> :cprevious<CR>

" key bind <Space>
" <Space>a search text
nnoremap <Space>a :tabnew<CR>:Ack<Space>
" <Space>b open buffers
nnoremap <Space>b :Buffers<CR>
" <Space>c open command list
nnoremap <Space>c :Commands<CR>

" <Space>f open file list
nnoremap <Space>f :Files<CR>

" <Space>h open helptag list
nnoremap <Space>h :Helptags<CR>

" <Space>h show markers
nnoremap <Space>m :marks<CR>

" カーソル下のワードをファイル名に含むファイルを検索
nnoremap <silent><Space>o :call myfunc#FindCurrentWord()<CR>

" <Space>q close buffer
nnoremap <Space>q :q<CR>
" <Space>r show registers
nnoremap <Space>r :registers<CR>

" <Space>s start shell
nnoremap <Space>s :sh<CR>
" <Space>t open tab list
nnoremap <silent><Space>t :call myfunc#FindTab()<CR>

" <Space>w write buffer to file
nnoremap <Space>w :w<CR>

" <Space>/ stop the highlight
nnoremap <Space>/ :nohlsearch<CR>

" edit mode key mapping

" <C-a> move to head
inoremap <C-a> <home>
" <C-e> move to end
inoremap <C-e> <end>
" <C-h> move to left
inoremap <C-h> <Left>
" <C-l> move to right
inoremap <C-l> <Right>
" <C-k> move to up
inoremap <C-k> <Up>
" <C-j> move to down
inoremap <C-j> <Down>

" <C-d> delete on cursor char
inoremap <C-d> <delete>

" curly brackets completion
inoremap {<Enter> {}<Left><CR><Left><ESC><S-o><Left>


" command line mode keymapping
" <C-a> move to head
cnoremap <C-a> <home>

" <C-e> move to end
cnoremap <C-e> <end>

" <C-h> move to left
cnoremap <C-h> <Left>

" <C-l> move to right
cnoremap <C-l> <Right>

" <C-d> delete on cursor char
cnoremap <C-d> <delete>

" only mac keymapping
if IsMac()
  nnoremap g@ :!~/Documents/lab/Tex/tex_compile.sh %<Enter>
endif
