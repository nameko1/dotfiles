local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

--local keymap = vim.keymap
local keymap = vim.api.nvim_set_keymap

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',

keymap("n", ";", ":", opts)
keymap("n", ":", ";", opts)

-- search word bring center
keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)

-- add/delete indent
keymap("n", "<<", "<<", opts)
keymap("n", ">>", ">>", opts)

-- move pane
keymap("n", "sh", "<C-w>h", opts)
keymap("n", "sj", "<C-w>j", opts)
keymap("n", "sk", "<C-w>k", opts)
keymap("n", "sl", "<C-w>l", opts)

-- change window size
keymap("n", "<C-h>", "<C-w><", opts)
keymap("n", "<C-l>", "<C-w>>", opts)
keymap("n", "<C-k>", "<C-w>-", opts)
keymap("n", "<C-j>", "<C-w>+", opts)

-- tab operations
keymap("n", "to", ":tabnew<CR>", opts)
--close current tab
keymap("n", "te", ":tabclose<CR> gT", opts)
--move next tab
keymap("n", "tl", ":tabnext<CR>", opts)
-- move previous tab
keymap("n", "th", ":tabprevious<CR>", opts)

-- memo
keymap("n", "<leader>mn", ":MemoNew<CR>", opts)
keymap("n", "<leader>ml", ":MemoList<CR>", opts)
keymap("n", "<leader>mg", ":MemoGrep<CR>", opts)

-- telescope shortcut
keymap("n", "<leader>b", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>c", ":Telescope commands<CR>", opts)
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>h", ":Telescope help_tags<CR>", opts)
keymap("n", "<leader>fb", ":Telescope file_browser<CR>", opts)
keymap("n", "<leader>lg", ":Telescope live_grep<CR>", opts)

-- github copilot
-- keymap("n", "<leader>cc", ":CopilotChatToggle<CR>", opts)

-- quit/write
keymap("n", "<leader>w", ":w<CR>", opts)
keymap("n", "<leader>q", ":q<CR>", opts)

keymap("n", "<leader>m", ":marks<CR>", opts)
keymap("n", "<leader>r", ":registers<CR>", opts)
-- keymap("n", "<leader>s", ":ToggleTerm<CR>", opts)
keymap("n", "<leader>/", ":nohlsearch<CR>", opts)

-- edit
keymap("n", "<CR>", "o<Esc>k", opts)

-- ToggleTerm
keymap("n", "<CR>", "o<Esc>k", opts)
keymap('t', '<C-t>', [[<C-\><C-n>]], opts)

-- lsp
keymap("n", "<leader>ld", ":lua vim.lsp.buf.definition()<CR>", opts)
keymap("n", "<leader>lr", ":lua vim.lsp.buf.references()<CR>", opts)
keymap("n", "<leader>le", ":lua vim.diagnostic.open_float()<CR>", opts)
vim.cmd("command Rename lua vim.lsp.buf.rename()")

-- edit mode key mapping
keymap("i", "<C-a>", "<home>", opts)
keymap("i", "<C-e>", "<end>", opts)
keymap("i", "<C-h>", "<Left>", opts)
keymap("i", "<C-l>", "<Right>", opts)
keymap("i", "<C-k>", "<Up>", opts)
keymap("i", "<C-j>", "<Down>", opts)
keymap("i", "<C-d>", "<delete>", opts)

-- command line mode keymapping
keymap("c", "<C-a>", "<home>", opts)
keymap("c", "<C-e>", "<end>", opts)
keymap("c", "<C-h>", "<Left>", opts)
keymap("c", "<C-l>", "<Right>", opts)
keymap("c", "<C-d>", "<delete>", opts)
