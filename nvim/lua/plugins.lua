return {
-- {
--  "zbirenbaum/copilot-cmp",
--   config = function ()
--     require("copilot_cmp").setup()
--   end
-- },
-- {
--   'github/copilot.vim',
--   lazy=false,
-- },
-- {
--     "CopilotC-Nvim/CopilotChat.nvim",
--     dependencies = {
--       { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
--       { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
--     },
--     build = "make tiktoken", -- Only on MacOS or Linux
--     opts = {
--       -- See Configuration section for options
--     },
-- },

-- git --
{ 
  "kdheepak/lazygit.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gi", "<cmd>LazyGit<CR>", desc = "LazyGit" },
    },
},
{ -- ファイルの変更状況などを可視化
	'leis6991/gitsigns.nvim',
    config = function()
        require('gitsigns').setup()
    end
},
-- git --

-- colorscheme --
{
    'folke/tokyonight.nvim',
    priority = 1000,
},
{
    'catppuccin/nvim',
},
-- colorscheme --

{ -- ctags
    'soramugi/auto-ctags.vim',
},
{ -- ctags
    'preservim/tagbar',
    config = function()
        vim.api.nvim_set_keymap('n', 'tt', ':TagbarToggle<CR>', {noremap = true})
    end
},
-- install without yarn or npm
{
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
},
-- edit -- 
{ -- auto complete surrounding pair
  -- https://github.com/kylechui/nvim-surround/blob/main/README.md
  --
  -- ys{motion}{char}
  -- ds{char}
  -- cs{target}{replacement}

  --    Old text                    Command         New text
  -- --------------------------------------------------------------------------------
  --     surr*ound_words             ysiw)           (surround_words)
  --     surr*ound_words             ysiw(           ( surround_words )
  --     *make strings               ys$"            "make strings"
  --     [delete ar*ound me!]        ds]             delete around me!
  --     remove <b>HTML t*ags</b>    dst             remove HTML tags
  --     'change quot*es'            cs'"            "change quotes"
  --     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
  --     delete(functi*on calls)     dsf             function calls

    'kylechui/nvim-surround',
    -- 既存fileを開いた時のみ
	-- 新規ファイルはBunNeFile
	event = "BufRead",

	config = function()
		require('nvim-surround').setup()
	end
},
{ -- memo
	'glidenote/memolist.vim',
	-- indepent
	-- go install github.com/mattn/memo@latest
	-- https://github.com/mattn/memo/blob/master/README.md
},
{ -- auto comment
    'numToStr/Comment.nvim',
    event = "BufRead",
    config = function()
        require('Comment').setup()
        vim.api.nvim_set_keymap('n', '<Space>g', 'gcc', {})
        vim.api.nvim_set_keymap('v', '<Space>g', 'gc', {})
    end
},
-- edit -- 

{ -- show file tree
    'nvim-neo-tree/neo-tree.nvim',
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    config = function()
        vim.api.nvim_set_keymap('n', '<C-e>', ':Neotree<CR>', {noremap = true})
    end
},
{ -- status line 
    'nvim-lualine/lualine.nvim',
    dependncies = {
        'kyazdani42/nvim-web-devicons'
    },
    config = function()
        require('lualine').setup({
            options = { theme = 'onedark' },
        })
    end
},
{ -- terminal
    'akinsho/toggleterm.nvim',
    priority = 0,
    config = function()
        require('toggleterm').setup({
            size = 100,
            direction = 'horizontal',
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            shade_terminals = true,
            start_in_insert = true,
            close_on_exit = true,
            direction = 'float',
            shade_filetypes = {},
            shading_factor = 2,
            insert_mappings = true,
            persist_size = true,
        })
    end
},
{
    'echasnovski/mini.indentscope',
    config = function()
        require('mini.indentscope').setup()
    end
},
{
    'pechorin/any-jump.vim',
},
{
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
},
-- telescope --
{ -- fuzzy finder
    'nvim-telescope/telescope.nvim',
},
{ -- fuzzy finder
    'delphinus/telescope-memo.nvim',
     requires = {
         'nvim-telescope/telescope.nvim',
     },
     config = function()
         require'telescope'.load_extension'memo'
     end,
},
{ -- fuzzy finder
    'nvim-telescope/telescope-file-browser.nvim',
},
-- telescope --

-- lsp --
{ -- lsp manager
    'williamboman/mason.nvim',
	-- uvではなくbrewのpythonを使う
    config = function()
		vim.env.PATH = "/opt/homebrew/bin:" .. vim.env.PATH
		require('mason').setup()
    end
},
{ -- lsp config
    'neovim/nvim-lspconfig',
    config = function()
        local lspconfig = require('lspconfig')
        lspconfig.ansiblels.setup{}
        lspconfig.pylsp.setup{
            settings = {
                pylsp = {
                    plugins = {
                        jedi = {
                            extra_paths = { "plugins" },
                        },
                        pycodestyle = {
                            ignore = {'H104,H405,H803,H904,E402,E501,E722'},
                            maxLineLength = 160
                        }
                    }
                }
            }
        }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to definition" })
    end
},
-- lsp --
{ -- complete
    'hrsh7th/nvim-cmp',
     config = function()
		 local cmp = require('cmp')
		 local has_words_before = function()
			 if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
			 local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			 return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
		 end
		 cmp.setup({
			 -- snippet = {
				 -- REQUIRED - you must specify a snippet engine
			 -- },
			 sources = cmp.config.sources({
				 { name = 'nvim_lsp' },
			 }, {
				 { name = 'buffer' },
				 { name = 'path' },
			 }),
	        cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = 'path' }
				}, {
					{ name = 'cmdline' }
				})
			}),
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ["<Tab>"] = vim.schedule_wrap(function(fallback)
                    if cmp.visible() and has_words_before() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                    else
                        fallback()
                    end
                end),
            }),
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
		 })
	 end
},
{
    'hrsh7th/cmp-nvim-lsp',
},
{
    'hrsh7th/cmp-buffer',
},
{
    'hrsh7th/cmp-path',
},
{
    'hrsh7th/cmp-cmdline',
    event = 'ModeChanged',
},
-- {
--     'hrsh7th/cmp-vsnip',
-- },
-- {
--     'hrsh7th/vim-vsnip',
-- },
-- {
--   "coder/claudecode.nvim",
--   dependencies = { "folke/snacks.nvim" },
--   opts = {
--     terminal_cmd = "~/.claude/local/claude", -- Point to local installation
--   },
--   config = true,
--   keys = {
--     { "<leader>a", nil, desc = "AI/Claude Code" },
--     { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
--     { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
--     { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
--     { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
--     { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
--     { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
--     { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
--     {
--       "<leader>as",
--       "<cmd>ClaudeCodeTreeAdd<cr>",
--       desc = "Add file",
--       ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
--     },
--     -- Diff management
--     { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
--     { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
--   },
-- }
}
