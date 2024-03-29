function! s:source_rc(path, ...) abort
  let s:abspath = expand('~/.vim/rc/' . a:path)
  execute 'source' fnameescape(s:abspath)
endfunction

" set augroup
augroup MyAutoCmd
autocmd!
" setting filetype
autocmd BufNewFile,BufRead *.blade.php setfiletype html
autocmd BufNewFile,BufRead *.tpl setfiletype html
augroup END

if has('vim_starting')
  call s:source_rc('init.rc.vim')
endif

call s:source_rc('dein.rc.vim')

call s:source_rc('statusline.rc.vim')

call s:source_rc('ddc.rc.vim')

syntax enable
filetype plugin indent on

call s:source_rc('options.rc.vim')
call s:source_rc('mappings.rc.vim')

set secure
