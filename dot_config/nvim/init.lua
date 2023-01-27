-- Plugins {{{1

-- Setup plugin loader {{{2
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = ' ' -- space is leader

require('lazy').setup({
	-- Completion and snippets {{{2
	'andersevenrud/cmp-tmux',
	'honza/vim-snippets',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-cmdline',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-nvim-lsp-signature-help',
	'hrsh7th/cmp-omni',
	'hrsh7th/cmp-path',
	'hrsh7th/nvim-cmp',
	'quangnguyen30192/cmp-nvim-ultisnips',
	'SirVer/ultisnips',

	-- Editing {{{2
	{
		'echasnovski/mini.nvim',
		version = false,
		config = function()
			require('mini.align').setup()
			require('mini.comment').setup()
			require('mini.jump').setup({
				-- Already repeats with 'f' and 't'.
				-- Leave this free for treesitter.
				repeat_jump = '',
			})
			require('mini.surround').setup()
			require('mini.trailspace').setup()
		end,
	},
	{
		'nvim-treesitter/nvim-treesitter-textobjects', -- {{{3
		config = function()
			local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
		end,
	},
	{
		'mg979/vim-visual-multi', -- {{{3
		keys = {
			{'<M-S-j>', '<Plug>(VM-Add-Cursor-Down)', 'n', desc = "Add cursor (down)"},
			{'<M-S-k>', '<Plug>(VM-Add-Cursor-Up)', 'n', desc = "Add cursor (up)"},
			{'<C-n>', '<Plug>(VM-Find-Under)', {'n', 'v'}, desc = "Add cursor (matching)"},
			{'<S-Right>', '<Plug>(VM-Select-l)', 'n', desc = "Select (right)"},
			{'<S-Left>', '<Plug>(VM-Select-h)', 'n', desc = "Select (left)"},
			{'\\A', '<Plug>(VM-Visual-All)', 'n', desc = "Select all matching"},
			{'\\/', '<Plug>(VM-Visual-Regex)', 'n', desc = "Select all matching regex"},
			{'\\f', '<Plug>(VM-Visual-Find)', 'n', desc = "Select all matching '/' register"},
		},
	},
	'machakann/vim-highlightedyank',
	{
		'nvim-treesitter/nvim-treesitter', -- {{{3
		build = ':TSUpdate',
		dependencies = {'nvim-treesitter/nvim-treesitter-textobjects'},
	},
	{'tpope/vim-abolish', command = "S"},
	'tpope/vim-repeat',
	'tpope/vim-sleuth',
	'vim-scripts/visualrepeat',
	'wsdjeg/vim-fetch',

	-- Filetype-specific {{{2
	'alker0/chezmoi.vim',
	{'cappyzawa/starlark.vim', ft = 'starlark'},
	'direnv/direnv.vim',
	{'habamax/vim-asciidoctor', ft = {'asciidoc', 'asciidoctor'}},
	{'hynek/vim-python-pep8-indent', ft = 'python'},
	{
		'iamcco/markdown-preview.nvim', -- {{{3
		ft = 'markdown',
		build = function()
			vim.fn['mkdp#util#install']()
		end,
		config = function()
			vim.g.mkdp_auto_close = 0
			vim.g.mkdp_filetypes = {'markdown'}
		end,
	},
	{'lervag/wiki.vim', ft = 'markdown'},
	{'NoahTheDuke/vim-just', ft = 'just'},
	{'rust-lang/rust.vim', ft = 'rust'},
	{'vim-pandoc/vim-pandoc-syntax', ft = {'markdown', 'pandoc'}},
	{'ziglang/zig.vim', ft = {'zig'}},

	-- Git {{{2
	{'rhysd/git-messenger.vim', keys = '<leader>gm'},
	{
		'tpope/vim-fugitive', -- {{{3
		dependencies = {'tpope/vim-rhubarb'},
		cmd = {"G", "Git", "GBrowse", "GRename"},
	},

	-- Look and feel {{{2
	'edkolev/tmuxline.vim',
	{
		'justinmk/molokai', -- {{{3
		lazy = false,
		priority = 1000,
	},
	{
		'vim-airline/vim-airline', -- {{{3
		dependencies = {'vim-airline/vim-airline-themes'},
		config = function()
			vim.cmd [[
				let g:airline_theme = "molokai"
				let g:airline#extensions#branch#displayed_head_limit = 10

				" We want to do this manually with,
				"   :Tmuxline airline | TmuxlineSnapshot ~/.tmux-molokai.conf
				let g:airline#extensions#tmuxline#enabled = 0
			]]
		end,
	},

	-- LSP and language features {{{2
	'folke/lsp-colors.nvim',
	'folke/trouble.nvim',
	'neovim/nvim-lspconfig',

	-- Navigation and window management {{{2
	{
		'camspiers/lens.vim', -- {{{3
		config = function()
			vim.g['lens#disabled_buftypes'] = {'quickfix'}
			vim.g['lens#animate']           = 0
		end,
	},
	'justinmk/vim-dirvish',
	{
		'mhinz/vim-grepper', -- {{{3
		config = function()
			vim.g.grepper = {
				tools        = {'rg', 'ag', 'git'},
				side         = 1,
				side_cmd     = 'new',
				prompt_text  = '$t> ',
				prompt_quote = 2,
				quickfix     = 1,
				switch       = 1,
				jump         = 0,
				dir          = 'filecwd',
				prompt_mapping_tool = '<leader>g',
			}
		end,
		keys = {
			{'<leader>gg', ':Grepper<cr>', 'n', noremap = true},
			{'gs', '<plug>(GrepperOperator)', 'n'},
			{'gs', '<plug>(GrepperOperator)', 'x'},
		},
	},
	{
		'nvim-telescope/telescope.nvim', -- {{{3
		tag = '0.1.1',
		dependencies = {'nvim-lua/plenary.nvim'},
	},
	'nvim-telescope/telescope-ui-select.nvim',
	'rbgrouleff/bclose.vim',
	{
		'folke/which-key.nvim', -- {{{3
		config = function()
			require('which-key').setup {}
		end,
	},

	-- Terminal integration {{{2
	{
		'christoomey/vim-tmux-navigator', -- {{{3
		config = function()
			-- We'll use our own mappings.
			vim.g.tmux_navigator_no_mappings = 1
		end,
		keys = {
			{'<C-J>', ':TmuxNavigateDown', 'n', noremap = true, silent = true},
			{'<C-K>', ':TmuxNavigateUp', 'n', noremap = true, silent = true},
			{'<C-L>', ':TmuxNavigateRight', 'n', noremap = true, silent = true},
			{'<C-H>', ':TmuxNavigateLeft', 'n', noremap = true, silent = true},
		},
	},
	{
		'ojroques/vim-oscyank', -- {{{3
		config = function()
			-- oscyank {{{2
			-- https://github.com/ojroques/vim-oscyank/issues/26#issuecomment-1179722561
			vim.g.oscyank_term = 'default'

			-- Set up a hook to send an OSC52 code if the system register is used.
			vim.api.nvim_create_autocmd("TextYankPost", {
				pattern = "*",
				callback = function(args)
					local ev = vim.v.event
					if ev.operator == 'y' and ev.regname == '+' then
						vim.cmd.OSCYankReg('+')
					end
				end,
			})
		end,
	},
	'vim-utils/vim-husk',
	{
		'voldikss/vim-floaterm', -- {{{3
		build = 'pip install --upgrade neovim-remote',
		config = function()
			let_g('floaterm_', {
				keymap_prev   = '<F4>',
				keymap_next   = '<F5>',
				autoclose     = 1,
				wintype       = 'floating',
			})
		end,
		keys = {
			{'<F6>', ':FloatermNew --height=0.4 --width=0.98 --cwd=<buffer> --position=bottom<CR>', 'n', silent = true, noremap = true},
			{'<F9>', ':FloatermToggle<CR>', 'n', silent = true, noremap = true},
		},
	},
})

-- General {{{1
if vim.env.VIM_PATH then
	vim.env.PATH = vim.env.VIM_PATH
end

local options = {
	compatible = false, -- no backwards compatibility with vi

	backup      = false, -- don't backup edited files
	writebackup = true, -- but temporarily backup before overwiting

	backspace = {'indent', 'eol', 'start'}, -- sane backspace handling

	ruler      = true, -- show the cursor position
	laststatus = 2,    -- always show status line
	showcmd    = true, -- display incomplete commands
	hidden     = true, -- allow buffers to be hidden without saving

	history    = 50, -- history of : commands
	wildmenu = true, -- show options for : completion

	number         = true, -- show line number of the current line and
	relativenumber = true, -- relative numbers of all other lines

	-- Use 8 tabs for indentation.
	expandtab   = false,
	softtabstop = 0,
	shiftwidth  = 8,
	tabstop     = 8,

	textwidth   = 79,    -- default to narrow text
	virtualedit = 'all', -- use virtual spaces
	scrolloff   = 5,     -- lines below cursor when scrolling

	-- Preserve existing indentation as much as possible.
	copyindent     = true,
	preserveindent = true,
	autoindent     = true,

	incsearch = true, -- show search results incrementally
	wrap      = false, -- don't wrap long lines

	-- Don't add two spaces after a punctuation when joining lines with J.
	joinspaces = false,

	ignorecase = true,        -- ignore caing during search
	smartcase  = true,        -- except if uppercase characters were used
	tagcase    = 'followscs', -- and use the same for tag searches

	inccommand = 'split', -- show :s results incrementally
	hlsearch = true, -- highlight search results

	lazyredraw = true,  -- don't redraw while running macros
	visualbell = true, -- don't beep
	mouse = 'a', -- support mouse

	background = 'dark',

	-- New splits should go below or to the right of the current window.
	splitbelow = true,
	splitright = true,

	foldmethod = 'marker', -- don't fold unless there are markers

	-- Timeout for partial key sequences.
	-- Needed for which-key.
	timeout = true,
	timeoutlen = 500,

	-- Show tabs and trailing spaces.
	list = true,
	listchars = {tab = '» ', trail = '.'},

	-- Patterns to ignore in wildcard expansions.
	wildignore = {
		'*/cabal-dev', '*/dist', '*.o', '*.class', '*.pyc', '*.hi',
	},

	completeopt = {'noinsert', 'menuone', 'noselect', 'preview'},
}

for name, val in pairs(options) do
	vim.opt[name] = val
end

-- Use true colors if we're not on Apple Terminal.
if vim.env.TERM_PROGRAM ~= 'Apple_Terminal' then
	vim.opt.termguicolors = true
end

-- let_g(table)
-- let_g(prefix, table)
--
-- Sets values on g:*. If prefix is non-empty, it's added to every key.
function let_g(prefix, opts)
	if opts == nil then
		opts, prefix = prefix, ''
	end

	for key, val in pairs(opts) do
		if prefix ~= '' then
			key = prefix .. key
		end
		vim.g[key] = val
	end
end

vim.cmd [[
colorscheme molokai

" Use terminal background for performance.
highlight Normal ctermbg=NONE guibg=NONE

" Make line numbers in terminal more readable
highlight LineNr ctermfg=245

" Invisible vertical split
highlight VertSplit guibg=bg guifg=bg

" Easier tabbing
nmap <silent> <C-M-T> :tabe<CR>
nmap <silent> <C-M-H> :tabp<CR>
nmap <silent> <C-M-L> :tabn<CR>

" Disable ex mode from Q
nnoremap Q <Nop>

" Clear highlights on enter
nnoremap <silent> <CR> :nohlsearch<CR><CR>

" Yank and paste operations preceded by <leader> should use system clipboard.
nnoremap <leader>y "+y
nnoremap <leader>Y "+yg_
vnoremap <leader>y "+y

nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Neovim specific configs.
if has('nvim')
	" Split navigation inside nvim's terminal emulator.
	tnoremap <C-M-J> <C-\><C-n><C-W><C-J>
	tnoremap <C-M-K> <C-\><C-n><C-W><C-K>
	tnoremap <C-M-L> <C-\><C-n><C-W><C-L>
	tnoremap <C-M-H> <C-\><C-n><C-W><C-H>
endif
]]

-- Edit the current vimrc
vim.keymap.set('n', '<leader>evf', ':e $MYVIMRC<cr>', {
	noremap = true,
	silent = true,
	desc = "Edit my vimrc",
})


-- Buffer shortcuts
vim.keymap.set('n', '<leader>q', ':bd<CR>', {
	desc = "Buffer delete",
	silent = true,
})
vim.keymap.set('n', '<leader>Q', ':bd!<CR>', {
	desc = "Buffer delete (force)",
	silent = true,
})
vim.keymap.set('n', '<leader>bn', ':bn<CR>', {
	desc = "Buffer next",
	silent = true,
})
vim.keymap.set('n', '<leader>bN', ':bN<CR>', {
	desc = "Buffer previous",
	silent = true,
})

vim.cmd [[
" Don't show line numbers in terminal.
autocmd TermOpen * setlocal nonu nornu

" Auto-reload files {{{2

" Trigger :checktime when changing buffers or coming back to vim.
augroup AutoReload
	autocmd!
	autocmd FocusGained,BufEnter * :checktime
augroup end
]]

-- Neovide {{{2
if vim.g.neovide then
	vim.opt.guifont = "Iosevka Term:h10"
	let_g('neovide_', {
		cursor_animation_length = 0,
	})
end

--  Plugin {{{1

-- nvim-cmp {{{2
local cmp = require 'cmp'
local cmp_ultisnips_mappings = require 'cmp_nvim_ultisnips.mappings'

local handleTab = function(fallback)
	if cmp.visible() then
		if cmp.get_selected_entry() ~= nil then
			cmp.confirm()
		else
			cmp.select_next_item()
		end
	elseif vim.fn['UltiSnips#CanJumpForwards']() == 1 then
		cmp_ultisnips_mappings.jump_forwards(fallback)
	else
		fallback()
	end
end

cmp.setup {
	completion = {
		keyword_length = 3,
	},
	snippet = {
		expand = function(args)
			vim.fn["UltiSnips#Anon"](args.body)
		end,
	},
	preselect = cmp.PreselectMode.None,
	mapping = cmp.mapping.preset.insert({
		-- Ctrl-u/d: scroll docs of completion item if available.
		['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),

		-- tab: If completion menu is visible and nothing has been selected,
		-- select first item. If something is selected, start completion with that.
		-- If in the middle of the completion, jump to next snippet position.

		-- Tab/Shift-Tab:
		-- If completion menu is not visible,
		--  1. if we're in the middle of a snippet, move forwards/backwards
		--  2. Otherwise use regular key behavior
		--
		-- If completion menu is visible and,
		--  1. no item is selected, select the first/last one
		--  2. an item is selected, start completion with it
		['<Tab>'] = cmp.mapping({
			i = handleTab,
			s = handleTab,
		}),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn['UltiSnips#CanJumpBackwards']() == 1 then
				cmp_ultisnips_mappings.jump_backwards(fallback)
			else
				fallback()
			end
		end, {'i', 's'}),

		-- Ctrl-Space: force completion
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),

		-- Ctr-e: cancel completion
		['<C-e>'] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),

		-- Enter: confirm completion
		['<CR>'] = cmp.mapping.confirm({select = false}),
	}),
	sources = cmp.config.sources({
		{name = 'nvim_lsp'},
		{name = 'nvim_lsp_signature_help'},
		{name = 'ultisnips'},
	}, {
		{name = 'path'},
		{name = 'buffer'},
		{name = 'tmux'},
	}),
}

cmp.setup.filetype('markdown', {
	sources = cmp.config.sources({
		{
			name = 'omni',
			trigger_characters = {"[["},
			keyword_length = 0,
			keyword_pattern = "\\w+",
		},
		{name = 'ultisnips'},
		{name = 'buffer'},
		{name = 'tmux'},
	}),
})

-- lspconfig {{{2
local nvim_lsp = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

function setup_lsp(server, lsp_opts)
	lsp_opts.on_attach = function(client, bufnr)
		local function buf_set_option(...)
			vim.api.nvim_buf_set_option(bufnr, ...)
		end

		local function lsp_nmap(key, fn, desc)
			vim.keymap.set('n', key, fn, {
				noremap = true,
				silent = true,
				desc = desc,
			})
		end

		buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
		local opts = { noremap = true, silent = true }

		-- Keybindings
		--  K            Documentation
		--  gd           Go to definition
		--  Alt-Enter    Code action

		lsp_nmap('K', vim.lsp.buf.hover, "Documentation")
		lsp_nmap('gd', vim.lsp.buf.definition, "Go to definition")
		lsp_nmap('<M-CR>', vim.lsp.buf.code_action, "Code action")

		local telescopes = require('telescope.builtin')
		-- Mneomonics:
		-- lr   Language rename
		-- lgr  Language go-to references
		-- lgr  Language go-to implementation
		-- lfr  Language find references
		-- lfd  Language find definitions
		-- lfw  Language find workspace
		lsp_nmap('<leader>lr', vim.lsp.buf.rename, "Rename")
		lsp_nmap('<leader>lgr', vim.lsp.buf.references, "Go to references")
		lsp_nmap('<leader>lgi', vim.lsp.buf.implementation, "Go to implementation")
		lsp_nmap('<leader>lfr', telescopes.lsp_references, "Search references")
		lsp_nmap('<leader>lfd', telescopes.lsp_document_symbols, "Search symbols (document)")
		lsp_nmap('<leader>lfw', telescopes.lsp_workspace_symbols, "Search symbols (workspace)")
	end

	lsp_opts.capabilities = lsp_capabilities
	lsp_opts.flags = {
		-- Don't spam LSP with changes. Wait a second between updates.
		debounce_text_changes = 1000,
	}

	nvim_lsp[server].setup(lsp_opts)
end

-- LSP implementations that don't need any configuration.
local default_lsps = {
	'clojure_lsp',
	'hie',
	'pylsp',
	'zls',
}

for _, server in pairs(default_lsps) do
	setup_lsp(server, {})
end

-- netrw {{{2
vim.g.netrw_liststyle = 3



-- telescope {{{2
local telescope = require('telescope')
local telescopes = require('telescope.builtin')
local teleactions = require('telescope.actions')
local telethemes = require('telescope.themes')
local teletrouble = require('trouble.providers.telescope')

telescope.setup {
	defaults = {
		mappings = {
			i = {
				-- Show help.
				["<C-h>"] = teleactions.which_key,
				-- Open in trouble.
				["<M-t>"] = teletrouble.open_with_trouble,
			},
		},
	},
	pickers = {
		buffers = {
			mappings = {
				i = {
					-- Ctrl-D in buffers to delete.
					["<C-d>"] = teleactions.delete_buffer,
				},
			},
		},
	},
	extensions = {
		["ui-select"] = {
			telethemes.get_dropdown {
			}
		},
	}
}

telescope.load_extension('ui-select')

-- All keys preceded by <leader>:
--
-- Mneomonics:
-- ff  find files
-- fF  find local files (buffer directory)
-- fb  find buffers
-- fh  find help
-- fr  find recent
-- ft  find treesitter
-- f?  "I forgot"
--
-- Others:
-- /  find in files
-- :  find ":" commands
vim.keymap.set('n', '<leader>f<leader>', telescopes.resume, {
	desc = "Find (resume)",
})
vim.keymap.set('n', '<leader>fF', function()
	telescopes.find_files({
		cwd = require('telescope.utils').buffer_dir(),
	})
end, {desc = "Find files (bufdir)"})
vim.keymap.set('n', '<leader>fb', function()
	telescopes.buffers {
		ignore_current_buffer = true,
	}
end, {desc = "Find buffers"})
vim.keymap.set('n', '<leader>fh', telescopes.help_tags, {
	desc = "Find help",
})
vim.keymap.set('n', '<leader>fr', telescopes.oldfiles, {
	desc = "Find recent files",
})
vim.keymap.set('n', '<leader>ft', telescopes.treesitter, {
	desc = "Find treesitter",
})
vim.keymap.set('n', '<leader>f?', telescopes.builtin, {
	desc = "Find telescopes",
})
vim.keymap.set('n', '<leader>/', telescopes.live_grep, {
	desc = "Find all files (grep)",
})
vim.keymap.set('n', '<leader>:', telescopes.commands, {
	desc = "Find commands",
})

-- tree-sitter {{{2
require 'nvim-treesitter.configs'.setup {
	ensure_installed = {
		"bash", "c", "cpp", "css", "dot", "gitignore", "go", "gomod",
		"gowork", "graphql", "html", "java", "javascript", "json",
		"lua", "make", "markdown", "markdown_inline", "perl", "php",
		"proto", "python", "regex", "rust", "ruby", "sql", "toml",
		"typescript", "vim", "yaml", "zig",
	},
	auto_install = true,
	highlight = {
		enable = true,
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				['af'] = {query = '@function.outer', desc = "a function"},
				['if'] = {query = '@function.inner', desc = "in function"},
				['ab'] = {query = '@block.outer', desc = "a block"},
				['ib'] = {query = '@block.inner', desc = "in block"},
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>al"] = {query = '@parameter.inner', desc = "Swap with next argument"},
			},
			swap_previous = {
				["<leader>ah"] = {query = '@parameter.inner', desc = "Swap with previous argument"},
			},
		},
		move = {
			enable = true,
			goto_next_start = {
				["]a"] = {query = "@parameter.inner", desc = "Next argument start"},
				["]f"] = {query = "@function.outer", desc = "Next function start"},
			},
			goto_next_end = {
				["]A"] = {query = "@parameter.inner", desc = "Next argument end"},
				["]F"] = {query = "@function.outer", desc = "Next function end"},
			},
			goto_previous_start = {
				["[a"] = {query = "@parameter.inner", desc = "Previous argument start"},
				["[f"] = {query = "@function.outer", desc = "Previous function start"},
			},
			goto_previous_end = {
				["[A"] = {query = "@parameter.inner", desc = "Previous argument end"},
				["[F"] = {query = "@function.outer", desc = "Previous function end"},
			},
		},
	},
}


-- trouble {{{2
local diagnostic_signs = {
	Error = '🚫',
	Warn  = '⚠️',
	Hint  = '💡',
	Info  = 'ℹ️',
}

for type, icon in pairs(diagnostic_signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, {
		text   = icon,
		texthl = hl,
		numhl  = hl,
	})
end

require('trouble').setup {
	auto_open = false,
	auto_close = true,
	auto_preview = true,

	action_keys = {
		close = "q",
		cancel = "<esc>",
		toggle_preview = "P",
	},

	-- Non-patched font:
	fold_open = "▼",
	fold_closed = "▶",
	icons = false,
	padding = false,
	indent_lines = false,
	group = true,
	signs = {
		error       = diagnostic_signs.Error,
		warning     = diagnostic_signs.Warn,
		hint        = diagnostic_signs.Hint,
		information = diagnostic_signs.Info,
	},
	use_lsp_diagnostic_signs = false,
}

-- Don't use virtual text to display diagnostics.
-- Signs in the gutter + trouble is enough.
vim.diagnostic.config({
	virtual_text = true,
})

--  File Types {{{1

-- go {{{2

-- Support disabling gopls and LSP by setting an environment variable,
-- and in diff mode.
local disable_gopls = vim.env.VIM_GOPLS_DISABLED or vim.opt.diff:get()

local gopls_options = {
	gofumpt     = true,
	staticcheck = true,
}

if vim.env.VIM_GOPLS_NO_GOFUMPT then
	gopls_options.gofumpt = false
end

if vim.env.VIM_GOPLS_BUILD_TAGS then
	gopls_options.buildFlags = {'-tags', vim.env.VIM_GOPLS_BUILD_TAGS}
end

-- Support overriding memory mode with an environment variable.
if vim.env.VIM_GOPLS_MEMORY_MODE then
	gopls_options.memoryMode = vim.env.VIM_GOPLS_MEMORY_MODE
end

if not disable_gopls then
	setup_lsp('gopls', {
		cmd = {'gopls', '-remote=auto'},
		init_options = gopls_options,
	})
end

-- markdown {{{2
vim.g['pandoc#syntax#conceal#use'] = 0

-- rust {{{2
vim.g.rustfmt_autosave = 1

-- lsp {{{3
setup_lsp('rust_analyzer', {
	settings = {
		['rust-analyzer'] = {
			completion = {
				postfix = {
					enable = false,
				},
			},
			checkOnSave = {
				command = "clippy",
			},
		},
	},
})

-- typescript {{{2
setup_lsp('tsserver', {
	init_options = {
		disableAutomaticTypingAcquisition = true,
	},
})

-- wiki.vim {{{2
let_g('wiki_', {
	filetypes = {'md'},
	index_name = 'README',
	link_extension = '.md',
	link_target_type = 'md',
	mappings_use_defaults = 'local',
	mappings_local = {
		['<plug>(wiki-link-follow)'] = '<leader><CR>',
	},
})
