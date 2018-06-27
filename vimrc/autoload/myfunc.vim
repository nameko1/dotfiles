"*************************************
" MyFunctions
"*************************************

"文字数カウント関数
" augroup CharCounter
"   autocmd!
"   " autocmd BufNew,BufEnter,BufWrite,InsertLeave * call <SID>Update()
"   autocmd BufEnter,CursorMoved,CursorMovedI * call <SID>Update()
" augroup END

" function! s:Update()
"   let b:charCounterCount = s:VisualCharCount()
" endfunction

" function! s:VisualCharCount()
"   let l:result = 0
"   for l:linenum in range(line('v'), line('.'))
"     let l:line = getline(l:linenum)
"     let l:result += strlen(substitute(l:line, '.', 'x', 'g'))
"   endfor
"   return l:result
" endfunction

" カーソル下の単語のつくファイルを検索するコマンド
function! myfunc#FindCurrentWord()
  let l:currentWord = expand('<cword>')
  call fzf#run(fzf#wrap({'options': '-m -q'.l:currentWord.get(g:, 'fzf_files_option', '')}))
endfunction

" マクロを編集するスクリプト
function! myfunc#EditMacro()
  let l:char = input("Which macro want to edit?\n")
  if strlen(matchstr(l:char, '^[a-z]$')) == 1
    let l:omacro = getreg(l:char, 0)
    let l:nmacro = input("\nEdit macro yourself\n", l:omacro)
    :call setreg(l:char, l:nmacro)
  en
endfunction


function! myfunc#FindTab() abort
  let l:result = fzf#run({'source': s:GetAllTabBuf(), 'down': '40%'})
  if len(l:result) == 0
    return
  endif
  call s:MoveTab(substitute(matchstr(l:result[0], '^\s\?[0-9]\+'), '^\s', '',''))
endfunction

function! s:GetAllTabBuf() abort
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

function! s:MoveTab(num) abort
  let l:currentTab = tabpagenr()
  let l:loop = a:num - l:currentTab
  if a:num <= l:currentTab
    let l:loop = tabpagenr('$') + l:loop
  endif
  for l:l in range(l:loop)
    tabnext
  endfor
endfunction

" tab番号を表示する
" Anywhere SID.
function! myfunc#SID_PREFIX()
  return matchstr(expand('<sfile>'),'<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! myfunc#my_tabline()
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

" update ctag file
function! myfunc#update_ctags() abort
  let l:tag_name = '.tags'
  let l:tags_path = findfile(l:tag_name, '.;')
  if l:tags_path ==# ''
    return
  endif

  let l:tags_dirpath = fnamemodify(l:tags_path, ':p:h')
  execute '!cd' l:tags_dirpath '&& ctags -R -f' l:tag_name '2> /dev/null &'
endfunction
