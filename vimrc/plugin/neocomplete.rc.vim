let g:neocomplete#enable_at_startup = 1            " neocomplete gets started autommatically
let g:neocomplete#enable_smart_case = 1            " when captital letter is included, not ignore the upper- and lowercase
let g:neocomplete#enable_camel_case = 1            " enable camel case match. (e.g., 'foB' is matched with 'FooBar' not 'foobar')

let g:neocomplete#auto_complete_delay = 50         " complete delay time after input
let g:neocomplete#min_keyword_length = 3           " length of keyword becoming the targets of the complete at the mininum
let g:neocomplete#enable_auto_select = 0           " neocomplete selects the first candidate automatically
let g:neocomplete#enable_auto_delimiter = 1        " insert delimiter automatically. (e.g., filinames '/' of vim scripts '#')

if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php =
      \ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:neocomplete#sources#dictionary#dictionaries = {
      \ 'default' : '',
      \ 'tex' : $HOME.'/.vim/dicts/tex.dict',
      \ }
" augroup OmniCompletion
"   autocmd!
"   autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"   autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"   autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"   autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"   autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" augroup END
