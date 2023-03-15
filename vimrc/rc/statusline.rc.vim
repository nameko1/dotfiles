"*************************************
" StatusLine
"*************************************

set showcmd "入力中のステータスに表示する
set laststatus=2 "ステータスラインを表示するウィンドウを設定する "2:常にステータスラインを表示する


let &g:statusline="%{NCwin(currentWin)}%#PWD#%{Cwin(currentWin)}%##"
\. "%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}"
\. "%c%V%6P"
" set statusline+=%=[wc=%{b:charCounterCount}]%8l,%c%V%8P "ステータスライン右側

function! Cwin(currentWin)
  return a:currentWin==winnr()?
        \substitute(getcwd(), $HOME, '~', '').'/':''
endfunction
function! NCwin(currentWin)
  return a:currentWin==winnr()?
        \'':substitute(getcwd(), $HOME, '~', '').'/'
endfunction

autocmd MyAutoCmd VimEnter,TabEnter,WinEnter * let currentWin=tabpagewinnr(tabpagenr())
