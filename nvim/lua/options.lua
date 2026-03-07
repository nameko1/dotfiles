-- leader
vim.g.mapleader = ' '
-- encoding
vim.o.encoding = 'utf-8'

-- search
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- tags
vim.o.tags = './tags'

vim.o.number = true
vim.o.showmatch = true
vim.o.matchtime = 1

-- visual
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true

-- autocmd
-- setfiletype
vim.api.nvim_create_autocmd({
    "BufNewFile",
    "BufEnter",
},
{
    pattern = {"*.yml"},
    command = "setfiletype yaml.ansible",
})

--memolist
vim.g.memolist_path = "~/.memolist/memo"
vim.g.memolist_memo_suffix = "md"
vim.g.memolist_fzf = 1
vim.g.memolist_template_dir_path = "~/.memolist/memotemplates"
