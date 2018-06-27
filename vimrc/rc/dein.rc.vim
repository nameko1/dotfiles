"*************************************
" Plugin install by Dein
"*************************************
let s:dein_dir = expand('$CACHE/dein')

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  "設定ファイルの読み込み
  call dein#load_toml('~/.vim/rc/dein.toml')

  "設定終わり
  call dein#end()
  call dein#save_state()
endif

"未インストールがあればいれる
if dein#check_install()
  call dein#install()
endif
