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
		'zbirenbaum/copilot.lua', -- {{{3
		command = 'Copilot',
		enabled = function()
			local disabled = vim.env.GITHUB_COPILOT_DISABLED
			if disabled == "1" or disabled == "true" then
				disabled = true
			else
				disabled = false
			end
			return not disabled
		end,
		config = function()
			-- Opt-into auto-triggering suggestions
			-- or opt-out of the whole thing with env vars.

			local auto_trigger = vim.env.GITHUB_COPILOT_AUTO_TRIGGER
			if auto_trigger == "1" or auto_trigger == "true" then
				auto_trigger = true
			else
				auto_trigger = false
			end

			-- Keymaps
			--
			-- <C-e>/<Tab> - Accept suggestion
			-- <M-.> - Next suggestion
			-- <M-,> - Previous suggestion
			-- <C-c> - Dismiss suggestion
			--
			-- Tab integration is implemented separately below
			-- to work with nvim-cmp and snippets.
			require('copilot').setup {
				suggestion = {
					enabled = true,
					auto_trigger = auto_trigger,
					keymap = {
						accept = '<C-e>',
						next = "<M-.>",
						prev = "<M-,>",
					},
				},
				filetypes = {
					["*"] = true, -- enable by default
					help = false,
				},
			}

			local copilot_suggestion = require 'copilot.suggestion'

			vim.keymap.set('n', '<leader>ct', function()
				copilot_suggestion.toggle_auto_trigger()
				if vim.b.copilot_suggestion_auto_trigger then
					print("Copilot: Auto-trigger enabled")
				else
					print("Copilot: Auto-trigger disabled")
				end
			end, {desc = "Toggle GitHub Copilot"})
		end,
	},
	{
		'echasnovski/mini.nvim',
		config = function()
			require('mini.align').setup()
			require('mini.comment').setup()

			require('mini.files').setup()
			vim.keymap.set('n', '-', function()
				local path = vim.api.nvim_buf_get_name(0)
				-- MiniFiles will attempt to focus on the file.
				-- If the file does not exist, give it the directory.
				if vim.fn.filereadable(path) == 0 then
					path = vim.fn.fnamemodify(path, ':h')
				end
				MiniFiles.open(path)
			end, {desc = "Open file explorer"})

			require('mini.jump').setup()
			require('mini.surround').setup()
			require('mini.trailspace').setup()
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
			{'\\\\A', '<Plug>(VM-Visual-All)', 'n', desc = "Select all matching"},
			{'\\\\/', '<Plug>(VM-Visual-Regex)', 'n', desc = "Select all matching regex"},
			{'\\\\f', '<Plug>(VM-Visual-Find)', 'n', desc = "Select all matching '/' register"},
		},
	},
	'machakann/vim-highlightedyank',
	{
		'nvim-treesitter/nvim-treesitter', -- {{{3
		build = ':TSUpdate',
		dependencies = {'nvim-treesitter/nvim-treesitter-textobjects'},
		config = function()
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "*",
				callback = function()
					local buf = vim.api.nvim_get_current_buf()
					local highlighter = require("vim.treesitter.highlighter")
					if highlighter.active[buf] then
						-- If treesitter is enabled for
						-- the current buffer,
						-- use it also for folding.
						vim.wo.foldmethod = 'expr'
						vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
						vim.wo.foldlevel = 5
						vim.wo.foldenable = false
					end
				end,
			})
		end,
	},
	{
		'nvim-treesitter/nvim-treesitter-context',
		dependencies = {'nvim-treesitter/nvim-treesitter'},
		config = function()
			require('treesitter-context').setup {
				enable = true,
			}
		end,
	},
	{'tpope/vim-abolish', command = "S"},
	'tpope/vim-repeat',
	'tpope/vim-sleuth',
	'vim-scripts/visualrepeat',
	'wsdjeg/vim-fetch',
	{
		'willothy/flatten.nvim',
		opts = function()
			-- Delete blocking buffers after they're closed.
			-- This ensures that buferes like git-rebase-todo, COMMIT_MSG, etc.
			-- don't remain open after the commit is finished,
			-- allowing another commit to be started.
			local blocking_buffers = {}
			return {
				window = {
					open = 'split',
				},
				block_for = {gitcommit = true, gitrebase = true},
				callbacks = {
					post_open = function(bufnr, _, _, is_blocking)
						if is_blocking then
							table.insert(blocking_buffers, bufnr)
						end
					end,
					block_end = function()
						for _, bufnr in ipairs(blocking_buffers) do
							vim.api.nvim_buf_delete(bufnr, {})
						end
						blocking_buffers = {}
					end,
				},
			}
		end,
		lazy = false,
		priority = 1001, -- run first
	},
	{
		'Wansmer/treesj', -- {{{3
		config = function()
			local tsj = require('treesj')
			tsj.setup {
				use_default_keymaps = false,
			}

			vim.keymap.set('n', '<leader>jj', tsj.toggle, { desc = "Toggle" })
			vim.keymap.set('n', '<leader>js', tsj.split,  { desc = "Split"  })
			vim.keymap.set('n', '<leader>jJ', tsj.join,   { desc = "Join"   })
		end,
	},

	-- Filetype-specific {{{2
	{'cappyzawa/starlark.vim', ft = 'starlark'},
	'direnv/direnv.vim',
	{'habamax/vim-asciidoctor', ft = {'asciidoc', 'asciidoctor'}},
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
	{
		'rafaelsq/nvim-goc.lua',
		ft = 'go',
		config = function()
			require('nvim-goc').setup()
		end,
	},
	{'rust-lang/rust.vim', ft = 'rust'},
	{'vim-pandoc/vim-pandoc-syntax', ft = {'markdown', 'pandoc'}},
	{
		'ziglang/zig.vim',
		ft = {'zig'},
		config = function()
			if vim.env.VIM_ZLS_DISABLED then
				vim.g.zig_fmt_autosave = 0
			end
		end,
	},

	-- Git {{{2
	{
		'ruifm/gitlinker.nvim',
		dependencies = {'nvim-lua/plenary.nvim'},
		config = function()
			require('gitlinker').setup()
		end,
	},
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			local gitsigns = require('gitsigns')
			gitsigns.setup {
				on_attach = function(bufnr)
					-- ]c, [c: next/prev hunk
					vim.keymap.set('n', ']c', function()
						if vim.wo.diff then
							return ']c'
						end
						vim.schedule(function()
							gitsigns.next_hunk()
						end)
						return '<Ignore>'
					end, {desc = "Next hunk", buffer = bufnr, expr = true})
					vim.keymap.set('n', '[c', function()
						if vim.wo.diff then
							return '[c'
						end
						vim.schedule(function()
							gitsigns.prev_hunk()
						end)
						return '<Ignore>'
					end, {desc = "Previous hunk", buffer = bufnr, expr = true})

					-- <leader>g{n,p}: next/prev hunk
					vim.keymap.set('n', '<leader>gn', gitsigns.next_hunk, {
						desc = "Next hunk",
						buffer = bufnr,
					})
					vim.keymap.set('n', '<leader>gp', gitsigns.prev_hunk, {
						desc = "Previous hunk",
						buffer = bufnr,
					})

					-- <leader>gm: blame current line
					vim.keymap.set('n', '<leader>gm', function()
						gitsigns.blame_line {full = true}
					end, {desc = "Blame current line"})


					-- <leader>gh{a,r}: stage and reset hunk
					vim.keymap.set('n', '<leader>gha', gitsigns.stage_hunk, {desc = "Stage hunk"})
					vim.keymap.set('n', '<leader>ghr', gitsigns.reset_hunk, {desc = "Reset hunk"})

					--
					vim.keymap.set('v', '<leader>gha', function()
						gitsigns.stage_hunk(vim.fn.line('.'), vim.fn.line('v'))
					end, {desc = "Stage hunk"})
					vim.keymap.set('v', '<leader>ghr', function()
						gitsigns.reset_hunk(vim.fn.line('.'), vim.fn.line('v'))
					end, {desc = "Reset hunk"})

					-- <leader>ghp: preview hunk
					vim.keymap.set('n', '<leader>ghp', gitsigns.preview_hunk, {desc = "Preview hunk"})

					-- <leader>gh{S,R}: stage and reset buffer
					vim.keymap.set('n', '<leader>ghA', gitsigns.stage_buffer, {desc = "Stage buffer"})
					vim.keymap.set('n', '<leader>ghR', gitsigns.reset_buffer, {desc = "Reset buffer"})

					-- <leader>gdi: diff index
					-- <leader>gdp: diff previous commit
					vim.keymap.set('n', '<leader>gdi', gitsigns.diffthis, {desc = "Diff (default base)"})
					vim.keymap.set('n', '<leader>gdp', function()
						gitsigns.diffthis('~')
					end, {desc = "Diff (parent)"})

					-- <leader>gtb: toggle line blame
					-- <leader>gtd: toggle deleted
					-- <leader>gtw: toggle word diff
					vim.keymap.set('n', '<leader>gtb', gitsigns.toggle_current_line_blame, {desc = "Line blame"})
					vim.keymap.set('n', '<leader>gtd', gitsigns.toggle_deleted, {desc = "Show deleted"})
					vim.keymap.set('n', '<leader>gtw', gitsigns.toggle_word_diff, {desc = "Word diff"})

					-- ih: hunk text object
					vim.keymap.set({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {
						desc = "Select hunk",
					})

					local function change_base(key, arg, desc)
						vim.keymap.set('n', '<leader>gb' .. key, function()
							gitsigns.change_base(arg)
						end, {desc = desc})
						vim.keymap.set('n', '<leader>gB' .. key, function()
							gitsigns.change_base(arg, true)
						end, {desc = desc .. ' (Global)'})
					end

					-- <leader>gbb: change base to index
					-- <leader>gbu: change base to upstream
					-- <leader>gbp: change base to parent commit
					--
					-- gB variants change base globally
					change_base('b', nil, "Set base to index")
					change_base('u', '@{upstream}', "Set base to upstream")
					change_base('p', '~', "Set base to parent commit")
				end,
			}
		end,
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
	'folke/trouble.nvim',
	{
		'folke/neodev.nvim',
		config = function()
			require('neodev').setup {
			}
		end,
	},
	{
		'neovim/nvim-lspconfig', -- {{{3
		dependencies = {
			'folke/lsp-colors.nvim',
			'folke/neodev.nvim', -- must init before lspconfig
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
		},
		-- Table of options for each language server.
		-- Items can be key-value pairs to specify configuration,
		-- and strings to use default configuration.
		-- The configuration can be a function.
		opts = {
			gopls = function()
				local init_opts = {
					gofumpt = not vim.env.VIM_GOPLS_NO_GOFUMPT,
					staticcheck = true,
					analyses = {
						-- "x.foo = y" when x is a struct value
						-- and not propagated or used afterwards.
						unusedwrite = true,
						-- Finds some common nil deref issues.
						nilness = true,
					},
				}
				if vim.env.VIM_GOPLS_BUILD_TAGS then
					init_opts.buildFlags = {
						'-tags', vim.env.VIM_GOPLS_BUILD_TAGS,
					}
				end
				if vim.env.VIM_GOPLS_NILNESS_DISABLED then
					-- nilness is resource-heavy.
					-- Allow opting out if necessary.
					init_opts.analyses.nilness = false
				end

				return {
					cmd = {'gopls', '-remote=auto'},
					init_options = init_opts,
				}
			end,
			omnisharp = {optional = true},
			'pylsp',
			lua_ls = {optional = true},
			rust_analyzer = {
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
			},
			tsserver = {
				init_options = {
					disableAutomaticTypingAcquisition = true,
				},
			},
			zls = {optional = true},
		},
		config = function(_, opts)
			local nvim_lsp = require('lspconfig')
			local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

			if vim.env.VIM_GOPLS_DISABLED then
				opts['gopls'] = nil
			end
			if vim.env.VIM_ZLS_DISABLED then
				opts['zls'] = nil
			end

			local ensure_installed = {}
			for name, cfg in pairs(opts) do
				if type(name) == "number" then
					name = cfg
					cfg = {}
				end
				if type(cfg) == "function" then
					cfg = cfg()
				end
				if cfg ~= nil then
					cfg.capabilities = lsp_capabilities
					cfg.flags = {
						-- Don't spam LSP with changes. Wait a second between updates.
						debounce_text_changes = 1000,
					}
					opts[name] = cfg

					-- If the LSP is installed globally,
					-- set it up.
					-- Otherwise, add it to the list of LSPs to install
					-- only if it's required.
					if vim.fn.executable(name) then
						nvim_lsp[name].setup(cfg)
					elseif not cfg.optional then
						table.insert(ensure_installed, name)
					end
				end
			end

			local mason_lspconfig = require('mason-lspconfig')
			mason_lspconfig.setup({
				ensure_installed = ensure_installed,
			})
			mason_lspconfig.setup_handlers({
				function(name)
					local cfg = opts[name]
					if cfg ~= nil then
						nvim_lsp[name].setup(opts[name])
					end
				end
			})
		end,
	},
	{
		'nvimtools/none-ls.nvim', -- {{{3
		dependencies = {
			'nvim-lua/plenary.nvim',
			'williamboman/mason.nvim',
		},
		config = function()
			local null_ls = require('null-ls')
			local sources = {
				null_ls.builtins.code_actions.shellcheck,
				null_ls.builtins.diagnostics.actionlint,
				null_ls.builtins.diagnostics.shellcheck,
				null_ls.builtins.formatting.jq,
				null_ls.builtins.formatting.shfmt,
			}
			if not (vim.env.VIM_GOLANGCI_LINT_DISABLED or vim.env.VIM_GOPLS_DISABLED) then
				sources[#sources + 1] = null_ls.builtins.diagnostics.golangci_lint
			end
			null_ls.setup({sources = sources})
		end,
	},
	{
		'williamboman/mason.nvim',
		opts = {
			ensure_installed = {
				'actionlint',
				'shellcheck', 'shfmt',
				'jq',
			},
		},
		config = function(_, opts)
			require('mason').setup(opts)

			local mr = require('mason-registry')
			for _, tool in ipairs(opts.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end,
	},

	-- Navigation and window management {{{2
	{
		'camspiers/lens.vim', -- {{{3
		config = function()
			vim.g['lens#disabled_buftypes'] = {'quickfix'}
			vim.g['lens#animate']           = 0
		end,
	},
	{
		'mhinz/vim-grepper', -- {{{3
		config = function()
			vim.g.grepper = {
				tools        = {'rg', 'git'},
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
			{'<leader>gg', ':Grepper<cr>', 'n', noremap = true, desc = "Grepper (interactive)"},
			{'gs', '<plug>(GrepperOperator)', {'n', 'x'}, desc = "Grepper (operator)"},
		},
	},
	{'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
	{
		'nvim-telescope/telescope.nvim', -- {{{3
		version = '*',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope-fzf-native.nvim',
		},
	},
	'nvim-telescope/telescope-ui-select.nvim',
	'rbgrouleff/bclose.vim',
	{
		'folke/which-key.nvim', -- {{{3
		opts = {
			spelling = {
				enabled = true,
			},
		},
		config = function(_, opts)
			local wk = require('which-key')
			wk.setup(opts)

			wk.register({
				mode = {'n', 'v'},
				["<leader>f"] = {name = "+find"},
				["<leader>g"] = {
					name = "+git",
					b    = "+change base",
					B    = "+change base (global)",
					h    = "+hunk",
					d    = "+diff",
					t    = "+toggle",
					y    = "Copy link",
				},
				["<leader>l"] = {
					name = "+language",
					g    = "+goto",
					f    = "+find",
				},
				["<leader>b"] = {name = "+buffer"},
				["<leader>j"] = {name = "+join/split"},
				["<leader>t"] = {name = "+terminals"},
				["<leader>T"] = {name = "+tabs"},
				["<leader>q"] = {name = "+quit"},
				["<leader>w"] = {name = "+windows"},
				["<leader>x"] = {name = "+diagnostics"},
			})
		end,
	},
	{
		'nvimtools/hydra.nvim', -- {{{3
		dependencies = {'mrjones2014/smart-splits.nvim'},
		config = function()
			local hydra = require('hydra')
			local splits = require('smart-splits')

			local cmd = require('hydra.keymap-util').cmd

			-- Window management submode:
			hydra({
				name = "Window",
				mode = 'n',
				body = '<C-w>',
				heads = {
					-- Navigate
					{'h', cmd('wincmd h'), {exit = true}},
					{'j', cmd('wincmd j'), {exit = true}},
					{'k', cmd('wincmd k'), {exit = true}},
					{'l', cmd('wincmd l'), {exit = true}},

					-- Resize
					{'<C-h>', function() splits.resize_left(10) end},
					{'<C-l>', function() splits.resize_right(10) end},
					{'<C-j>', function() splits.resize_down(10) end},
					{'<C-k>', function() splits.resize_up(10) end},
					{'=', cmd('wincmd ='), {
						desc = "Equalize splits",
						exit = true,
					}},

					-- Split
					{'s', cmd('split')},
					{'v', cmd('vsplit')},

					-- Others
					{'c', cmd('close')},
					{'o', cmd('wincmd o'), {exit = true}},
				},
			})
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
	'lambdalisue/vim-manpager',
	{
		'ojroques/vim-oscyank', -- {{{3
		config = function()
			-- oscyank {{{2
			-- https://github.com/ojroques/vim-oscyank/issues/26#issuecomment-1179722561
			vim.g.oscyank_term = 'default'

			-- Set up a hook to send an OSC52 code if the system register is used.
			vim.g.oscyank_autocmd_id = vim.api.nvim_create_autocmd("TextYankPost", {
				pattern = "*",
				callback = function(_)
					local ev = vim.v.event
					if ev.operator == 'y' and ev.regname == '+' then
						vim.cmd 'OSCYankRegister +'
					end
				end,
			})
		end,
	},
	'vim-utils/vim-husk',
	{
		'akinsho/toggleterm.nvim', -- {{{3
		config = function()
			require('toggleterm').setup {
				direction = 'horizontal',
				on_exit = function(term)
					-- Delete the terminal when closed.
					-- Otherwise, it will be re-used and
					-- the old dir= will persist.
					term:shutdown()
				end,
			}
		end,
		keys = {
			{'<F6>', ':ToggleTerm dir=%:p:h name=bufdir<CR>', 'n', silent = true, noremap = true},
			{'<F9>', ':ToggleTerm name=cwd<CR>', 'n', silent = true, noremap = true},
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

	number         = false, -- show line number of the current line and
	relativenumber = false, -- relative numbers of all other lines

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
	list = false,
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
local function let_g(prefix, opts)
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

" Add a line below the treesitter context.
hi TreesitterContextBottom gui=underline guisp=gray
]]

-- Quit
vim.keymap.set('n', '<leader>qq', ':qa<cr>', {desc = "Quit all"})

-- Disable ex mode from Q.
vim.keymap.set('n', 'Q', '<Nop>', {noremap = true})

-- Yank and paste operations preceded by <leader> should use system clipboard.
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', {
	noremap = true,
	desc = "Yank to clipboard",
})
vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', {
	noremap = true,
	desc = "Paste from clipboard (above)",
})
vim.keymap.set({'n', 'v'}, '<leader>P', '"+P', {
	noremap = true,
	desc = "Paste from clipboard (below)",
})

vim.keymap.set('t', '<M-Esc>', [[<C-\><C-n>]], {
	noremap = true,
	desc = "Exit terminal insert mode",
})

-- Split navigation inside :terminal
vim.keymap.set('t', '<C-J>', [[<C-\><C-n><C-W><C-J>]], {
	noremap = true,
	desc = 'Move to split below',
})
vim.keymap.set('t', '<C-K>', [[<C-\><C-n><C-W><C-K>]], {
	noremap = true,
	desc = 'Move to split above',
})
vim.keymap.set('t', '<C-L>', [[<C-\><C-n><C-W><C-L>]], {
	noremap = true,
	desc = 'Move to split right',
})
vim.keymap.set('t', '<C-H>', [[<C-\><C-n><C-W><C-H>]], {
	noremap = true,
	desc = 'Move to split left',
})

-- Clear highlight after search.
vim.keymap.set('n', '<CR>', ':nohlsearch<CR><CR>', {
	silent = true,
	noremap = true,
})

-- Edit the current vimrc
vim.keymap.set('n', '<leader>evf', ':e $MYVIMRC<cr>', {
	noremap = true,
	silent = true,
	desc = "Edit my vimrc",
})

-- Tab shortcuts
vim.keymap.set('n', '<leader>Td', ':tabclose<CR>', {
	desc = 'Close tab',
	silent = true,
})

-- Terminal shortcuts.
vim.keymap.set('n', '<leader>tt', ':vnew | terminal<CR>', {
	desc = "New terminal in a vertical split",
	silent = true,
})
vim.keymap.set('n', '<leader>th', ':new | terminal<CR>', {
	desc = "New terminal in a horizontal split",
	silent = true,
})
vim.keymap.set('n', '<leader>tT', ':tabnew | terminal<CR>', {
	desc = "New terminal in a new tab",
	silent = true,
})

-- Buffer shortcuts
vim.keymap.set('n', '<leader>bd', ':bd<CR>', {
	desc = "Delete buffer",
	silent = true,
})
vim.keymap.set('n', '<leader>bD', ':bd!<CR>', {
	desc = "Delete buffer (force)",
	silent = true,
})
vim.keymap.set('n', '<leader>bn', ':bn<CR>', {
	desc = "Next buffer",
	silent = true,
})
vim.keymap.set('n', '<leader>bN', ':bN<CR>', {
	desc = "Previous buffer",
	silent = true,
})

-- Window shortcuts
vim.keymap.set('n', '<leader>wd', '<C-W>c', {
	desc = "Delete window",
	silent = true,
})
vim.keymap.set('n', '<leader>wv', '<C-W>v', {
	desc = "Split window vertically",
	silent = true,
})
vim.keymap.set('n', '<leader>ws', '<C-W>s', {
	desc = "Split window horizontally",
	silent = true,
})
vim.keymap.set('n', '<leader>ws', '<C-W>o', {
	desc = "Hide all other windows",
	silent = true,
})

vim.cmd [[
" Don't show line numbers in terminal.
autocmd TermOpen * setlocal nonu nornu | startinsert

" Close on program exit.
autocmd TermClose * execute 'bdelete!'

" Auto-reload files {{{2

" Trigger :checktime when changing buffers or coming back to vim.
augroup AutoReload
	autocmd!
	autocmd FocusGained,BufEnter * :checktime
augroup end
]]

--Terminal color scheme {{{2
let_g('terminal_color_', {
	['0']  = '#000000', -- black
	['1']  = '#ec392c', -- red
	['2']  = '#b3e439', -- green
	['3']  = '#fea525', -- yellow
	['4']  = '#cfa3ff', -- blue
	['5']  = '#fd4285', -- magenta
	['6']  = '#76dff3', -- cyan
	['7']  = '#f4f4f4', -- white

	['8']  = '#676767', -- bright black
	['9']  = '#ff4036', -- bright red
	['10'] = '#c5fa41', -- bright green
	['11'] = '#ffb450', -- bright yellow
	['12'] = '#dfc2ff', -- bright blue
	['13'] = '#ff679f', -- bright magenta
	['14'] = '#9aefff', -- bright cyan
	['15'] = '#feffff', -- bright white
})

-- Neovide {{{2
if vim.g.neovide then
	vim.opt.guifont = "Iosevka Term:h10"
	vim.opt.linespace = -1
	let_g('neovide_', {
		cursor_animation_length = 0,
		scroll_animation_length = 0.1,
		-- Treat alt as Meta instead of sending special characters.
		input_macos_alt_is_meta = true,
		input_use_logo = true, -- Use Win/MacOS/Super key
	})

	local scale_factor = vim.env.NEOVIDE_SCALE_FACTOR
	if scale_factor then
		scale_factor = tonumber(scale_factor)
	else
		scale_factor = 1.0
	end
	-- HACK: Setting the scale factor at startup races sometimes.
	vim.defer_fn(function()
 		vim.g.neovide_scale_factor = scale_factor
	end, 500)

	-- Support adjusting scale factor with Cmd = and Cmd -.
	local adjust_scale_factor = function(delta)
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
	end
	vim.keymap.set('n', '<D-=>', function()
		adjust_scale_factor(1.25)
	end, {desc = "Increase scale factor"})
	vim.keymap.set('n', '<D-->', function()
		adjust_scale_factor(1/1.25)
	end, {desc = "Decrease scale factor"})
	vim.keymap.set('n', '<D-0>', function()
		vim.g.neovide_scale_factor = 1.0
	end, {desc = "Reset scale factor"})

	-- Super+C/V for copy-paste.
	vim.keymap.set({'n', 'v'}, '<D-c>', '"+y')
	vim.keymap.set({'n', 'v'}, '<D-v>', '"+P')
	vim.keymap.set({'c', 'i'}, '<D-v>', '<C-R>+') -- cmd and insert mode

	-- Super+T, W, Left, Right for tab navigation.
	vim.keymap.set('n', '<D-t>', ':tabnew<CR>', {desc = "New tab"})
	vim.keymap.set('n', '<D-w>', ':tabclose<CR>', {desc = "Close tab"})
	vim.keymap.set('n', '<D-Left>', ':tabprevious<CR>', {desc = "Previous tab"})
	vim.keymap.set('n', '<D-Right>', ':tabnext<CR>', {desc = "Next tab"})

	-- HACK: OSC52 is not supported in neovide.
	if vim.g.oscyank_autocmd_id then
		vim.api.nvim_del_autocmd(vim.g.oscyank_autocmd_id)
	end
end

--  Plugin {{{1

-- lspconfig {{{2

local function lsp_on_attach(_, bufnr)
	local function lsp_nmap(key, fn, desc)
		vim.keymap.set('n', key, fn, {
			noremap = true,
			silent = true,
			desc = desc,
			buffer = bufnr,
		})
	end

	vim.bo.omnifunc =  'v:lua.vim.lsp.omnifunc'

	-- Keybindings
	--  K            Documentation
	--  gd           Go to definition
	--  Alt-Enter    Code action

	lsp_nmap('K', vim.lsp.buf.hover, "Documentation")
	lsp_nmap('gd', vim.lsp.buf.definition, "Go to definition")

	local telescopes = require('telescope.builtin')
	-- lgr  Language go-to references
	-- lgi  Language go-to implementation
	-- lfr  Language find references
	-- lfi  Language find implementations
	-- lfd  Language find symbols (document)
	-- lfw  Language find symbols (workspace)
	lsp_nmap('<leader>lgr', vim.lsp.buf.references, "Go to references")
	lsp_nmap('<leader>lgi', vim.lsp.buf.implementation, "Go to implementation")
	lsp_nmap('<leader>lfr', telescopes.lsp_references, "Find references")
	lsp_nmap('<leader>lfi', telescopes.lsp_implementations, "Find implementations")
	lsp_nmap('<leader>lfd', telescopes.lsp_document_symbols, "Find symbols (document)")
	lsp_nmap('<leader>lfw', telescopes.lsp_workspace_symbols, "Find symbols (workspace)")

	-- Mneomonics:
	-- cr   Code rename
	-- cf   Code format
	-- ca   Code action
	lsp_nmap('<leader>ca', vim.lsp.buf.code_action, "Code action")
	lsp_nmap('<leader>cf', vim.lsp.buf.format, "Reformat file")
	lsp_nmap('<leader>cr', vim.lsp.buf.rename, "Rename")
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local buffer = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		lsp_on_attach(client, buffer)
	end,
})

-- nvim-cmp {{{2
local cmp = require 'cmp'
local cmp_ultisnips_mappings = require 'cmp_nvim_ultisnips.mappings'
local has_copilot, copilot_suggestion = pcall(require, 'copilot.suggestion')

local handleTab = function(fallback)
	-- Completion suggestions take precedence over Copilot suggestions.
	-- Copilot suggestions are still accessible with <C-e>.
	if cmp.visible() then
		if cmp.get_selected_entry() ~= nil then
			cmp.confirm()
		else
			cmp.select_next_item()
		end
	elseif has_copilot and copilot_suggestion.is_visible() then
		copilot_suggestion.accept()
	elseif vim.fn['UltiSnips#CanJumpForwards']() == 1 then
		cmp_ultisnips_mappings.jump_forwards(fallback)
	else
		fallback()
	end
end

local handleCancel = function(cancelFn)
	return function(fallback)
		local used = false
		if cmp.visible() then
			cancelFn()
			used = true
		end
		if  has_copilot and copilot_suggestion.is_visible() then
			copilot_suggestion.dismiss()
			used = true
		end
		if not used then
			fallback()
		end
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
	mapping = {
		['<Down>'] = {i = cmp.mapping.select_next_item()},
		['<C-n>']  = {i = cmp.mapping.select_next_item()},
		['<Up>']   = {i = cmp.mapping.select_prev_item()},
		['<C-p>']  = {i = cmp.mapping.select_prev_item()},

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

		-- Ctrl-c: cancel completion
		['<C-c>'] = cmp.mapping({
			i = handleCancel(cmp.mapping.abort()),
			c = handleCancel(cmp.mapping.close()),
		}),

		-- Enter: confirm completion
		['<CR>'] = cmp.mapping.confirm({select = false}),
	},
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

-- mini.files {{{2
local mapFilesSplit = function(bufID, key, direction)
	vim.keymap.set('n', key, function()
		-- Create a new split and set it as the target.
		local currentTarget = MiniFiles.get_target_window()
		if currentTarget == nil then
			currentTarget = vim.api.nvim_get_current_win()
		end

		local targetWindow
		vim.api.nvim_win_call(currentTarget, function()
			vim.cmd(direction .. ' split')
			targetWindow = vim.api.nvim_get_current_win()
		end)
		MiniFiles.set_target_window(targetWindow)
		MiniFiles.go_in({})
	end, { buffer = bufID, desc = 'Split ' .. direction })
end

-- Custom keymaps for MiniFiles.
--
-- Ctrl-v: open in vertical split
-- Ctrl-h: open in horizontal split
-- -: go up (matches keybinding to open explorer)
-- `: cd to focused directory or parent of file
-- Enter: open file or enter directory
-- Ctrl-p: toggle preview
-- Ctrl-c, Esc: close
vim.api.nvim_create_autocmd('User', {
	pattern = 'MiniFilesBufferCreate',
	callback = function(args)
		local bufID = args.data.buf_id
		mapFilesSplit(bufID, '<C-v>', 'vertical')
		mapFilesSplit(bufID, '<C-h>', 'horizontal')

		vim.keymap.set('n', '-', function()
			MiniFiles.go_out()
		end, { buffer = bufID, desc = 'Go up' })
		vim.keymap.set('n', '<CR>', function()
			MiniFiles.go_in({
				close_on_file = true,
			})
		end, { buffer = bufID, desc = 'Open file or directory' })

		vim.keymap.set('n', '<C-c>', function()
			MiniFiles.close()
		end, { buffer = bufID, desc = 'Close' })
		vim.keymap.set('n', '<Esc>', function()
			MiniFiles.close()
		end, { buffer = bufID, desc = 'Close' })

		vim.keymap.set('n', '`', function()
			local curEntry = MiniFiles.get_fs_entry()
			if curEntry == nil then
				return
			end
			local curDir = curEntry.path
			if curEntry.fs_type == 'file' then
				curDir = vim.fs.dirname(curDir)
			end
			vim.fn.chdir(curDir)
		end, { buffer = bufID, desc = 'Change current directory' })

		local show_preview = false
		vim.keymap.set('n', '<C-p>', function()
			show_preview = not show_preview
			MiniFiles.refresh({
				windows = {
					preview = show_preview,
					width_preview = 50,
				},
			})
			MiniFiles.trim_right()
		end, { buffer = bufID, desc = 'Toggle preview' })
	end,
})

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
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		["ui-select"] = {
			telethemes.get_dropdown {
			}
		},
	}
}

telescope.load_extension('ui-select')
telescope.load_extension('fzf')

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
-- ?  find in files (buffer directory)
-- :  find ":" commands
vim.keymap.set('n', '<leader>f<leader>', telescopes.resume, {
	desc = "Find (resume)",
})
vim.keymap.set('n', '<leader>ff', telescopes.find_files, {desc = "Find files"})
vim.keymap.set('n', '<leader>fF', function()
	telescopes.find_files({
		cwd = require('telescope.utils').buffer_dir(),
	})
end, {desc = "Find files (bufdir)"})

local function find_buffers()
	telescopes.buffers {
		ignore_current_buffer = true,
	}
end
vim.keymap.set('n', '<leader>fb', find_buffers, {desc = "Find buffers"})
vim.keymap.set('n', '<leader>bf', find_buffers, {desc = "Find buffers"})

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
	desc = "Find in files",
})
vim.keymap.set('n', '<leader>?', function()
	telescopes.live_grep({
		cwd = require('telescope.utils').buffer_dir(),
	})
end, {desc = "Find in files (bufdir)"})
vim.keymap.set('n', '<leader>:', telescopes.commands, {
	desc = "Find commands",
})

-- tree-sitter {{{2
require 'nvim-treesitter.configs'.setup {
	modules = {},
	ensure_installed = {
		"bash", "c", "cpp", "css", "dot",
		"gitignore", "go", "gomod", "gowork", "graphql",
		"html", "java", "javascript", "json",
		"lua", "make", "markdown", "markdown_inline",
		"perl", "php", "proto", "python",
		"regex", "rust", "ruby",
		"sql", "toml", "typescript",
		"vim", "yaml", "zig",
	},
	sync_install = false,
	auto_install = true,
	-- The gitcommit tree-sitter parser does not support highlighting in
	-- verbose mode itself; it expects injections for those.
	-- However, the query injections defined in tree-sitter-gitcommit
	-- aren't picked up for some reason.
	ignore_install = {"gitcommit", "diff"},
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
	auto_preview = false,

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

vim.keymap.set('n', '<leader>xx', ':TroubleToggle<cr>', {desc = "Diagnostics list"})
vim.keymap.set('n', '<leader>xl', ':lopen<cr>', {desc = "Location list"})
vim.keymap.set('n', '<leader>xq', ':copen<cr>', {desc = "Quickfix list"})
vim.keymap.set('n', '<leader>xn', function()
	vim.diagnostic.goto_next({float = false, wrap = false})
end, {desc = "Next diagnostic"})

vim.keymap.set('n', '<leader>xp', function()
	vim.diagnostic.goto_prev({float = false, wrap = false})
end, {desc = "Previous diagnostic"})

--  File Types {{{1

-- markdown {{{2
vim.g['pandoc#syntax#conceal#use'] = 0

-- rust {{{2
vim.g.rustfmt_autosave = 1

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
