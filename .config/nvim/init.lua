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

require('lazy').setup({
	-- Completion and snippets {{{2
	'andersevenrud/cmp-tmux',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-cmdline',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-nvim-lsp-signature-help',
	'hrsh7th/cmp-omni',
	'hrsh7th/cmp-path',
	'hrsh7th/nvim-cmp',
	'rafamadriz/friendly-snippets',
	{
		'garymjr/nvim-snippets',
		config = function()
			require('snippets').setup {
				create_cmp_source = true,
				friendly_snippets = true,
				search_paths = {
					vim.fn.stdpath('config') .. '/snippets',
				},
			}
		end,
	},
	{
		"chrisgrieser/nvim-scissors",
		dependencies = {
			"folke/snacks.nvim",
			"garymjr/nvim-snippets",
		},
		opts = {
			snippetDir = vim.fn.stdpath('config') .. '/snippets',
			jsonFormatter = "jq",
		},
	},

	-- Editing {{{2
	{
		'folke/snacks.nvim',
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = {}, -- disable expensive features for big files
			notifier = {}, -- prettier notifications
			scratch = {}, -- easily create scratch buffers
			quickfile = {}, -- render files before loading plugins
			terminal = {},
			toggle = {},

			-- Fuzzy finder
			picker = {
				win = {
					input = {
						keys = {
							-- Close on ESC.
							["<Esc>"] = { "close", mode = { "n", "i" } },
						},
					},
				},
			},

			-- Kitty image protocol support
			image = {
				math = { enabled = false },
			},

			-- Link to current file in Git repo
			gitbrowse = {
				enabled = true,
				notify = false,
				open = function(url)
					-- Instead of opening the URL in a browser,
					-- copy it to the clipboard and notify the user.
					vim.fn.setreg('+', url)
					Snacks.notify.info('Coplied to clipboard:\n' .. url, {
						title = "gitbrowse",
					})
				end,
			},
		},
		keys = {
			-- gitbrowse
			{'<leader>gy', function()
				Snacks.gitbrowse()
			end, mode = {'n', 'v'}, desc = "Git: Copy link to file"},

			-- scratch
			{'<leader>.', function()
				Snacks.scratch()
			end, desc = "Toggle scratch buffer"},
			{'<leader>f.', function()
				Snacks.scratch.select()
			end, desc = "Toggle scratch buffer"},

			-- picker
			-- All keys preceded by <leader>:
			--
			-- Mnemonics:
			--
			-- ff  find files
			-- FF  find local files (buffer directory)
			-- fb  find buffers
			-- fh  find help
			-- fr  find recent
			-- ft  find treesitter
			-- fs  find search operator
			{'<leader>ff', function() Snacks.picker.files() end, desc = 'Find files'},
			{'<leader>FF', function()
				Snacks.picker.files({ cwd = vim.fn.expand('%:p:h') })
			end, desc = 'Find files (buffer directory)' },
			{'<leader>fb', function() Snacks.picker.buffers({
				current = false,
				win = {
					input = {
						keys = {
							['<C-d>'] = {'bufdelete', mode = {'n', 'i'}},
						},
					},
				},
			}) end, desc = 'Find buffers'},
			{'<leader>fh', function() Snacks.picker.help() end, desc = 'Find help'},
			{'<leader>fr', function() Snacks.picker.recent() end, desc = 'Find recent files'},
			{'<leader>ft', function() Snacks.picker.treesitter() end, desc = 'Find treesitter symbols'},

			-- Others:
			-- /  find in files
			-- ?  find in files (buffer directory)
			-- :  find ":" commands
			{'<leader>/', function() Snacks.picker.grep() end, desc = 'Find in files'},
			{'<leader>?', function()
				Snacks.picker.grep({ dirs = {vim.fn.expand('%:p:h')} })
			end, desc = 'Find in files (buffer directory)'},
			{'<leader>:', function() Snacks.picker.commands() end, desc = 'Find ":" commands'},
		},
	},
	{
		"folke/todo-comments.nvim",
		dependencies = {"nvim-lua/plenary.nvim"},
		keys = {
			{'<leader>fT', function()
				Snacks.picker.todo_comments()
			end, desc = "Find TODO comments"},
			{']t', function() require('todo-comments').jump_next() end, desc = "Next TODO comment"},
			{'[t', function() require('todo-comments').jump_prev() end, desc = "Previous TODO comment"},
		},
		lazy = false,
		opts = {
			signs = false, -- don't clutter the gutter
		},
	},
	{
		'zbirenbaum/copilot.lua', -- {{{3
		dependencies = {"folke/snacks.nvim"},
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
			-- or opt-out of the whole thing
			-- with environment variables.

			local auto_trigger = vim.env.GITHUB_COPILOT_AUTO_TRIGGER
			if auto_trigger == "1" or auto_trigger == "true" then
				auto_trigger = true
			else
				auto_trigger = false
			end

			Snacks.toggle.new({
				id = "github_copilot",
				name = "GitHub CoPilot",
				get = function()
					if vim.b.copilot_suggestion_auto_trigger ~= nil then
						return vim.b.copilot_suggestion_auto_trigger
					end

					return auto_trigger
				end,
				set = function(state)
					vim.b.copilot_suggestion_auto_trigger = state
				end,
			})

			-- Key maps
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
		end,
	},
	{
		'stevearc/oil.nvim',
		config = function()
			require('oil').setup {
				skip_confirm_for_simple_edits = true,
				prompt_save_on_select_new_entry = false,
				use_default_keymaps = false,
				view_options = {
					show_hidden = true,
				},
				keymaps = {
					["g?"]    = "actions.show_help",
					["<CR>"]  = "actions.select",
					["<C-v>"] = "actions.select_vsplit",
					["<C-s>"] = "actions.select_split",
					["<C-t>"] = "actions.select_tab",
					["<C-p>"] = "actions.preview",
					["<C-c>"] = "actions.close",
					["<C-r>"] = "actions.refresh",
					["-"]     = "actions.parent",
					["`"]     = "actions.cd",
					["."]     = "actions.toggle_hidden",
				},
			}

			vim.keymap.set("n", "-", "<CMD>Oil<CR>", {
				desc = "Open parent directory",
			})

			-- https://github.com/stevearc/oil.nvim/issues/234
			vim.api.nvim_create_autocmd("BufLeave", {
				pattern  = "oil:///*",
				callback = function ()
					vim.cmd("cd .")
				end
			})

			-- https://github.com/stevearc/oil.nvim/issues/44
			vim.cmd.cabbr({ args = {
				"<expr>",
				"%",
				"&filetype == 'oil' ? bufname('%')[6:-2] : '%'",
			} })

			-- When a file is renamed, inform LSPs of the change.
			vim.api.nvim_create_autocmd('User', {
				pattern = 'OilActionsPost',
				callback = function(event)
					e = event.data.actions
					if e.type == "move" then
						Snacks.rename.on_rename_file(e.src_url, e.dest_url)
					end
				end,
			})

		end,
	},
	{
		'echasnovski/mini.nvim',
		config = function()
			require('mini.align').setup()
			require('mini.jump').setup()
			require('mini.surround').setup {
				mappings = {
					add = '<leader>sa',
					delete = '<leader>sd',
					find = '',
					find_left = '',
					highlight = '',
					replace = '<leader>sr',
 					update_n_lines = '',
 				},
 				n_lines = 100,
			}
			require('mini.trailspace').setup()
		end,
	},
	{
		'Bekaboo/deadcolumn.nvim', -- {{{3
		opts = {
			modes = function(mode)
				-- This is the default modes setting
				-- plus 'n'.
				return mode:find('^[nictRss\x13]') ~= nil
			end,
			extra = {
				-- Highlight the column after textwidth as we
				-- approach it.
				follow_tw = "+1",
			},
		},
	},
	{
		'mg979/vim-visual-multi', -- {{{3
		lazy = false,
		keys = {
			{'<M-S-j>', '<Plug>(VM-Add-Cursor-Down)', 'n', desc = "Add cursor (down)"},
			{'<M-S-k>', '<Plug>(VM-Add-Cursor-Up)', 'n', desc = "Add cursor (up)"},
			{'<C-n>', '<Plug>(VM-Find-Under)', {'n', 'v'}, desc = "Add cursor (matching)"},
			{'\\\\A', '<Plug>(VM-Visual-All)', 'n', desc = "Select all matching"},
			{'\\\\/', '<Plug>(VM-Visual-Regex)', 'n', desc = "Select all matching regex"},
		},
	},
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
		'andymass/vim-matchup',
		config = function()
			-- Adjust highlighting of matching pairs
			-- to be less intrusive.
			vim.api.nvim_create_autocmd('ColorScheme', {
				callback = function()
					vim.api.nvim_set_hl(0, "MatchParen", {
						fg = '#ef5939',
						ctermfg = 203,
						bold = true,
					})
				end,
			})
		end
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			modes = {
				-- Don't mess with normal f/t motions.
				char = { enabled = false },
			},
			highlight = {
				matches = false,
			},
		},
		keys = {
			-- Jump around with 's{search}'.
			{ "s", mode = { "n", "x", "o" }, function()
				require("flash").jump()
			end, desc = "Flash jump" },
			{ "S", mode = { "n", "x", "o" }, function()
				require("flash").treesitter()
			end, desc = "Flash treesitter" },
			-- New motion:
			-- '{verb}' followed by 'r{search}' to move to a
			-- different position and run the verb there
			-- with a new motion.
			{ "r", mode = "o", function()
				require("flash").remote()
			end, desc = "Flash remote operator" },
			{ "R", mode = { "o", "x" }, function()
				require("flash").treesitter_search()
			end, desc = "Treesitter Search" },
		},
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
			-- This ensures that buffers like git-rebase-todo, COMMIT_MSG, etc.
			-- don't remain open after the commit is finished,
			-- allowing another commit to be started.
			local blocking_buffers = {}
			return {
				window = {
					open = 'split',
				},
				block_for = {gitcommit = true, gitrebase = true},
				hooks = {
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

	-- File-type-specific {{{2
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
	{'rust-lang/rust.vim', ft = 'rust'},
	{'Vimjas/vim-python-pep8-indent', ft = 'python'},
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
		'lewis6991/gitsigns.nvim',
		dependencies = {"folke/snacks.nvim"},
		config = function()
			local gitsigns = require('gitsigns')
			gitsigns.setup()

			-- <leader>g{n,p}: next/prev hunk
			-- Works in both, diff mode and normal mode.
			vim.keymap.set('n', '<leader>gn', function()
				local diff_mode = vim.api.nvim_get_option_value('diff', { win = 0 })
				if diff_mode then
					vim.cmd('normal ]c')
				else
					gitsigns.next_hunk()
				end
			end, {desc = "Next hunk"})
			vim.keymap.set('n', '<leader>gp', function()
				local diff_mode = vim.api.nvim_get_option_value('diff', { win = 0 })
				if diff_mode then
					vim.cmd('normal [c')
				else
					gitsigns.prev_hunk()
				end
			end, {desc = "Previous hunk"})

			-- <leader>gm: blame current line
			vim.keymap.set('n', '<leader>gm', function()
				gitsigns.blame_line {full = true}
			end, {desc = "Blame current line"})

			local gitsigns_config = require('gitsigns.config').config
			Snacks.toggle.new({
				id = "gitsigns_current_line_blame",
				name = "Blame current line",
				get = function()
					return gitsigns_config.current_line_blame
				end,
				set = function(state)
					gitsigns.toggle_current_line_blame(state)
				end,
			})
			Snacks.toggle.new({
				id = "gitsigns_show_deleted",
				name = "Show deleted hunks",
				get = function()
					return gitsigns_config.show_deleted
				end,
				set = function(state)
					gitsigns.toggle_deleted(state)
				end,
			})
			Snacks.toggle.new({
				id = "gitsigns_word_diff",
				name = "Word-level diff",
				get = function()
					return gitsigns_config.word_diff
				end,
				set = function(state)
					gitsigns.toggle_word_diff(state)
				end,
			})

			-- <leader>gh{a,r}: stage and reset hunk
			vim.keymap.set('n', '<leader>gha', gitsigns.stage_hunk, {desc = "Stage hunk"})
			vim.keymap.set('n', '<leader>ghr', gitsigns.reset_hunk, {desc = "Reset hunk"})

			-- visual mode variants
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

			local function change_base(key, arg, desc)
				vim.keymap.set('n', '<leader>gb' .. key, function()
					gitsigns.change_base(arg, true)
				end, {desc = desc})
				vim.keymap.set('n', '<leader>gB' .. key, function()
					gitsigns.change_base(arg)
				end, {desc = desc .. ' (Buffer)'})
			end

			-- <leader>gbb: change base to index
			-- <leader>gbu: change base to upstream
			-- <leader>gbp: change base to parent commit
			-- <leader>gba: change base to argument supplied in a prompt
			--
			-- gB variants change base for this buffer only
			change_base('b', nil, "Set base to index")
			change_base('u', '@{upstream}', "Set base to upstream")
			change_base('p', '~', "Set base to parent commit")

			local function change_base_prompt(keys, global, desc)
				vim.keymap.set('n', '<leader>g' .. keys, function()
					vim.ui.input({prompt = "Base commit: "}, function(input)
						if input == nil or input == '' then
							return
						end
						gitsigns.change_base(input, global)
					end)
				end, {desc = desc})
			end

			change_base_prompt('ba', true, "Set base to argument")
			change_base_prompt('Ba', false, "Set base to argument (buffer)")
		end,
	},
	{
		"sindrets/diffview.nvim",
		config = function()
			local diffview = require('diffview')
			local actions = require('diffview.actions')
			diffview.setup({
				use_icons = true,
				enhanced_diff_hl = true,
				keymaps = {
					view = {
						{'n', 'q', ':DiffviewClose<CR>', {desc = "Close diffview"}},
					},
					file_panel = {
						{'n', 'q', ':DiffviewClose<CR>', {desc = "Close diffview"}}
					},
				},
			})

			-- <leader>gdd: open diffview with default base
			-- <leader>gda: open diffview with base supplied in a prompt
			-- <leader>gdu: open diffview with base set to upstream
			-- <leader>gdp: open diffview with base set to parent commit
			-- <leader>gdq: close diffview

			vim.keymap.set('n', '<leader>gdd', function()
				local base_args = {}
				local gitsigns_base = require('gitsigns.config').config.base
				if gitsigns_base ~= nil then
					base_args = {gitsigns_base}
				end

				diffview.open(base_args)
			end, {desc = "Diffview"})

			vim.keymap.set('n', '<leader>gda', function()
				vim.ui.input({prompt = "Base commit: "}, function(input)
					if input == nil or input == '' then
						return
					end
					diffview.open({input})
				end)
			end, {desc = "Diffview (prompt)"})

			vim.keymap.set('n', '<leader>gdu', function()
				diffview.open({'@{upstream}'})
			end, {desc = "Diffview (upstream)"})
			vim.keymap.set('n', '<leader>gdp', function()
				diffview.open({'HEAD~'})
			end, {desc = "Diffview (parent commit)"})

			vim.keymap.set('n', '<leader>gdq', function()
				diffview.close()
			end, {desc = "Close Diffview"})

			-- <leader>gdh: open file history
			-- <leader>gdf: open file history for current buffer
			vim.keymap.set('n', '<leader>gdh', function()
				diffview.file_history()
			end, {desc = "File history"})
			vim.keymap.set('n', '<leader>gdf', function()
				local file = vim.fn.expand('%')
				if file == '' then
					Snacks.notify.warn("No file", {title = "Diffview"})
					return
				end
				diffview.file_history(nil, {file})
			end, {desc = "File history (current buffer)"})
		end,
	},
	{
        	"NeogitOrg/neogit",
        	branch = 'master',
        	dependencies = {
                	"nvim-lua/plenary.nvim",
                	"sindrets/diffview.nvim",
                	"folke/snacks.nvim",
        	},
        	config = function()
                	local neogit = require('neogit')
                	neogit.setup {
                        	remember_settings = false,
                        	graph_style = 'kitty', -- also works in Ghostty
                        	-- Don't auto-enter insert mode when committing.
                        	disable_insert_on_commit = true,
                        	integrations = {
                        		diffview = true,
                        		snacks = true,
                        	},
                	}

                	vim.keymap.set('n', '<leader>gg', function()
                        	neogit.open({ cwd = vim.fn.expand('%:p:h') })
                	end, {desc = "Open neogit"})
        	end,
	},

	-- Look and feel {{{2
	{
		'justinmk/molokai', -- {{{3
		lazy = false,
		priority = 1000,
	},
	{
		'nvim-lualine/lualine.nvim', -- {{{3
		config = function()
			local custom_molokai = require('lualine.themes.molokai')
			-- Get rid of the loud pink background.
			custom_molokai.normal.b = {fg = '#808080', bg = '#232526'}

			require('lualine').setup {
				options = {
					theme = custom_molokai,
				},
				sections = {
					lualine_a = {'mode'},
					lualine_b = {'branch', 'diff', 'diagnostics'},
					lualine_c = {
						{'filename', color=custom_molokai.inactive.c},
					},
					lualine_x = {
						{'encoding', color=custom_molokai.inactive.c},
						{'fileformat', color=custom_molokai.inactive.c},
						{'filetype', color=custom_molokai.inactive.c},
					},
					lualine_y = {'progress'},
					lualine_z = {'location'}
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {'filename'},
					lualine_x = {'location'},
					lualine_y = {},
					lualine_z = {}
				},
			}
		end,
	},
	{
		'nvim-tree/nvim-web-devicons',
		config = function()
			require('nvim-web-devicons').setup {
				default = true,
			}
		end,
	},

	-- LSP and language features {{{2
	'folke/trouble.nvim',
	'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
	{
		'neovim/nvim-lspconfig', -- {{{3
		dependencies = {
			'folke/lsp-colors.nvim',
			 { "mason-org/mason.nvim", opts = {} },
			'mason-org/mason-lspconfig.nvim',
		},
		-- Table of options for each language server.
		-- Items can be key-value pairs to specify configuration,
		-- and strings to use default configuration.
		-- The configuration can be a function.
		opts = {
			'bashls',
			gopls = function()
				local init_opts = {
					gofumpt = not vim.env.VIM_GOPLS_NO_GOFUMPT,
					staticcheck = true,
					hints = {
						compositeLiteralFields = true,
						parameterNames = true,
					},
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
					-- nilness check is resource-heavy.
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
			rust_analyzer = {
				settings = {
					['rust-analyzer'] = {
						completion = {
							postfix = {
								enable = false,
							},
						},
						checkOnSave = true,
					},
				},
			},
			ts_ls = {
				init_options = {
					disableAutomaticTypingAcquisition = true,
				},
			},
			starpls = {optional = true},
			zls = {optional = true},
		},
		config = function(_, opts)
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

					-- If the LSP is installed globally, set it up.
					--
					-- Otherwise, add it to the list of LSPs to install
					-- only if it's required.
					-- Mason will enable them automatically.
					if vim.fn.executable(name) then
						vim.lsp.config(name, cfg)
					elseif not cfg.optional then
						table.insert(ensure_installed, name)
					end
				end
			end

			local mason_lspconfig = require('mason-lspconfig')
			mason_lspconfig.setup({
				ensure_installed = ensure_installed,
				automatic_enable = true,
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
				null_ls.builtins.diagnostics.actionlint,
				null_ls.builtins.diagnostics.buf,
				null_ls.builtins.formatting.shfmt,
				null_ls.builtins.formatting.buf,
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
				'shellcheck',
				'shfmt',
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
	{
		'ray-x/go.nvim',
		dependencies = {
			'neovim/nvim-lspconfig',
			'nvim-treesitter/nvim-treesitter',
		},
		config = function()
			require('go').setup {
				trouble = true,
				lsp_inlay_hints = {
					enable = false,
				},
			}
		end,
		event = {'CmdlineEnter'},
		ft = {'go', 'gomod'},
	},
	{
		'rgroli/other.nvim',
		config = function()
			require('other-nvim').setup {
				mappings = {
					'golang',
					'python',
					'rust',
				},
				showMissingFiles = true,
				style = {
					newFileIndicator = '(+)',
				},
			}

			vim.keymap.set('n', '<leader>eaa', '<cmd>:Other<CR>', {
				desc = "Open alternate file",
				silent = true,
			})
			vim.keymap.set('n', '<leader>eav', '<cmd>:OtherVSplit<CR>', {
				desc = "Open alternate file (vertical split)",
				silent = true,
			})
			vim.keymap.set('n', '<leader>eas', '<cmd>:OtherSplit<CR>', {
				desc = "Open alternate file (split)",
				silent = true,
			})
			vim.keymap.set('n', '<leader>eat', '<cmd>:OtherTabNew<CR>', {
				desc = "Open alternate file (tab)",
				silent = true,
			})

		end,
	},

	-- Navigation and window management {{{2
	'nanotee/zoxide.vim',
	'Bekaboo/dropbar.nvim',
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

			wk.add({
				mode = {'n', 'v'},
				{"<leader>g", group = "git"},
				{"<leader>gd", group = "+diff"},
 				{"<leader>gb", desc = "+change base"},
 				{"<leader>gB", desc = "+change base (buffer)"},
 				{"<leader>gh", desc = "+hunk"},

 				{"<leader>e", group = "+edit"},
 				{"<leader>ea", group = "+alternate"},

				{"<leader>T", group = "+terminals"},

				{"<leader>b", group = "+buffer"},
				{"<leader>f", group = "+find"},
				{"<leader>j", group = "+join/split"},
				{"<leader>q", group = "+quit"},

				{"<leader>u", group = "+toggles"},
				{'<leader>ul', group = '+lsp'},
				{'<leader>ug', group = '+git'},

				{"<leader>s", group = "+surround"},
				{"<leader>t", group = "+tabs"},
				{"<leader>w", group = "+windows"},
				{"<leader>x", group = "+diagnostics"},
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
		'alexghergh/nvim-tmux-navigation', -- {{{3
		config = function()
			require('nvim-tmux-navigation').setup {
				keybindings = {
					left = '<C-h>',
					right = '<C-l>',
					up = '<C-k>',
					down = '<C-j>',
				},
			}

		end,
	},
	'lambdalisue/vim-manpager',
	'vim-utils/vim-husk',
})

-- General {{{1
if vim.env.VIM_PATH then
	vim.env.PATH = vim.env.VIM_PATH
end

-- Don't use Python integration.
-- It just wreaks havoc anytime a virtualenv gets involved.
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0

local options = {
	compatible = false, -- no backwards compatibility with vi

	backup      = false, -- don't backup edited files
	writebackup = true, -- but temporarily backup before overwriting

	backspace = {'indent', 'eol', 'start'}, -- sane backspace handling

	ruler      = true, -- show the cursor position
	laststatus = 2,    -- always show status line
	showcmd    = true, -- display incomplete commands
	hidden     = true, -- allow buffers to be hidden without saving
	spell      = true, -- enable spell checking
	spelloptions = {
		'noplainbuffer', -- don't check spelling in plain buffers
		'camel',         -- check camelCase words
	},

	-- By default, only add the user-level spellfile.
	-- Down below, an autocommand will add a project-local files.
	spellfile  = vim.env.HOME .. '/.config/nvim/spell/en.utf-8.add',

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

	ignorecase = true,        -- ignore casing during search
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

-- Use dictionary for completion suggestions.
vim.opt.complete:append('kspell')

-- When showing diffs, fill deleted lines with this.
vim.opt.fillchars:append {diff = '·'}

vim.cmd [[
colorscheme molokai

" Use terminal background for performance.
highlight Normal ctermbg=NONE guibg=NONE

" Invisible vertical split
highlight VertSplit guibg=bg guifg=bg

" Add a line below the treesitter context.
highlight TreesitterContextBottom gui=underline guisp=gray

" Make neogit diff highlights more readable.
highlight NeogitDiffAdd ctermfg=white guifg=white ctermbg=NONE guibg=NONE
highlight NeogitDiffAddHighlight ctermfg=47 guifg=#2bff2b ctermbg=NONE guibg=NONE

" highlight typos louder
highlight SpellBad guibg=#770000
]]

-- Spell-checking
local function setlocal_nospell(args)
	local winid = vim.api.nvim_get_current_win()
	vim.wo[winid][0].spell = false
end

local no_spellcheck_languages = {
	'help',
	'man',
	'qf',
	'oil',
	'gitrebase',
}
vim.api.nvim_create_autocmd('FileType', {
	pattern = no_spellcheck_languages,
	callback = setlocal_nospell,
	desc = "Opt-out filetypes from spell-checking",
})

vim.api.nvim_create_autocmd('TermOpen', {
	pattern = "*",
	callback = setlocal_nospell,
	desc = "Opt-out terminals from spell-checking",
})

-- Upon opening a file, attempt to detect its project root,
-- and if found, use a spell file in that directory.
local function setlocal_project_spellfile()
	local root_dir = vim.fs.root(0, '.git')

	-- If root directory is HOME, don't use a project-local spellfile.
	if root_dir == vim.env.HOME then
		return nil
	end

	-- Otherwise, use .vimspell.en.utf-8.add in the project root,
	-- or fall back to just one in the current directory.
	local local_spellfile = '.vimspell.en.utf-8.add'
	if root_dir ~= nil then
		local_spellfile = root_dir .. '/' .. local_spellfile
	end

	if vim.fn.filereadable(local_spellfile) then
		vim.bo.spellfile = local_spellfile .. ',' .. vim.bo.spellfile
	end
end
vim.api.nvim_create_autocmd('BufReadPost', {
	pattern = "*",
	callback = setlocal_project_spellfile,
	desc = "Set up project-local spell file",
})


vim.keymap.set('n', '<leader>zg', function()
	-- Determine position of last spellfile.
	local _, idx = string.gsub(vim.bo.spellfile, ',', '')
	local count = idx + 1

	-- Add the bad word to the end of the list.
	local badword = vim.fn.spellbadword()[1]
	if badword ~= '' then
		vim.cmd(count .. 'spellgood ' .. badword)
	end
end, { desc = 'Add as good word (global list)' })

vim.keymap.set('n', '<leader>zw', function()
	local _, idx = string.gsub(vim.bo.spellfile, ',', '')
	local count = idx + 1
	local word = vim.fn.expand('<cword>')
	vim.cmd(count .. 'spellwrong ' .. word)
end, { desc = 'Add as bad word (global list)' })

-- Change the theme to use Search highlight for IncSearch too.
vim.api.nvim_set_hl(0, "IncSearch", vim.api.nvim_get_hl(0, {name = "Search"}))

-- Highlight selections
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank {
			higroup = "IncSearch",
			timeout = 350,
		}
	end,
})

-- Quit
vim.keymap.set('n', '<leader>qq', ':qa<cr>', {desc = "Quit all"})

-- Disable ex mode from Q.
vim.keymap.set('n', 'Q', '<Nop>', {noremap = true})

-- Disable horizontal mouse scrolling.
vim.keymap.set({'i', 'v', 'n'}, '<ScrollWheelLeft>', '<Nop>', {noremap = true})
vim.keymap.set({'i', 'v', 'n'}, '<ScrollWheelRight>', '<Nop>', {noremap = true})
vim.keymap.set({'i', 'v', 'n'}, '<S-ScrollWheelLeft>', '<Nop>', {noremap = true})
vim.keymap.set({'i', 'v', 'n'}, '<S-ScrollWheelRight>', '<Nop>', {noremap = true})

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
vim.keymap.set('n', '<leader>tt', ':tabnew<CR>', {
	desc = 'New tab',
	silent = true,
})
vim.keymap.set('n', '<leader>td', ':tabclose<CR>', {
	desc = 'Close tab',
	silent = true,
})
vim.keymap.set('n', '<leader>tn', ':tabnext<CR>', {
	desc = 'Next tab',
	silent = true,
})
vim.keymap.set('n', '<leader>tN', ':tabprevious<CR>', {
	desc = 'Previous tab',
	silent = true,
})

-- Terminal shortcuts.
vim.keymap.set('n', '<leader>TT', function()
	Snacks.terminal.open(nil, {
		win = {position = "right"},
		interactive = true,
	})
end, {
	desc = "New terminal in a vertical split",
	silent = true,
})
vim.keymap.set('n', '<leader>TH', function()
	Snacks.terminal.open(nil, {
		win = {position = "bottom"},
		interactive = true,
	})
end, {
	desc = "New terminal in a horizontal split",
	silent = true,
})

-- <leader>fy: copy relative file path
vim.keymap.set('n', '<leader>fy', function()
	local filepath = vim.fn.expand('%')
	if filepath == '' then
		Snacks.notify.warn("No file path", {title = "Yank buffer path"})
		return
	end

	-- Usually, the buffer path is enough.
	-- But sometimes, the buffer path is absolute,
	-- in which case make it relative to cwd.
	if string.sub(filepath, 1, 1) == '/' then
		local cwd = vim.fn.getcwd() .. '/'
		if string.sub(filepath, 1, #cwd) == cwd then
			filepath = string.sub(filepath, #cwd + 1)
		end
	end

	vim.fn.setreg('+', filepath)
	Snacks.notify.info("Copied: " .. filepath, {title = "Yank buffer path"})
end, {noremap = true, desc = "Copy relative file path to clipboard"})

-- F9:
--   (in tmux) open tmux split in current buffer directory.
--   (in vim without tmux) open terminal in current buffer directory.
vim.keymap.set('n', '<F9>', function()
	local in_tmux = vim.env.TMUX ~= nil and not vim.g.neovide

	local buffer_dir = vim.fn.expand('%:p:h')
	if buffer_dir == '' or buffer_dir == '.' then
		buffer_dir = vim.fn.getcwd()
	end

	if not in_tmux then
		Snacks.terminal.open(nil, {
			cwd = buffer_dir,
			win = {position = "right"},
			interactive = true,
		})
	else
		vim.fn.system({'tmux', 'split-window', '-h', '-c', buffer_dir})
	end
end, {
	desc = "Open tmux split in current buffer's directory",
	silent = true,
})

-- Buffer shortcuts
vim.keymap.set('n', '<leader>bd', function()
	Snacks.bufdelete()
end, { desc = "Delete buffer", silent = true })
vim.keymap.set('n', '<leader>bD', function()
	Snacks.bufdelete({ force = true })
end, { desc = "Delete buffer (force)", silent = true })
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

-- Auto-reload changed files by triggering :checktime
-- when changing buffers or coming back to vim.
vim.api.nvim_create_autocmd({"FocusGained", "BufEnter"}, {
	pattern = "*",
	callback = function()
		vim.cmd.checktime()
	end,
})

-- Terminal: Enter insert mode immediately on enter.
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.cmd.startinsert()
	end,
})

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
	vim.opt.guifont = "Pragmasevka Nerd Font:h14"
	vim.opt.linespace = -1
	let_g('neovide_', {
		cursor_animation_length = 0.00,
		cursor_animate_command_line = false,
		scroll_animation_length = 0.1,
		-- Treat alt as Meta instead of sending special characters.
		input_macos_option_key_is_meta = "both",
		input_use_logo = true, -- Use Win/MacOS/Super key
	})

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
	vim.keymap.set({'n', 'v'}, '<D-c>', '"+y', { noremap = true })
	vim.keymap.set({'n', 'v'}, '<D-v>', '"+p', { noremap = true })
	vim.keymap.set({'c', 'i'}, '<D-v>', '<ESC>"+p', { noremap = true })
	vim.keymap.set('t', '<D-v>', [[<C-\><C-n>"+Pi]], { noremap = true })

	-- Super+T, W, Left, Right for tab navigation.
	vim.keymap.set('n', '<D-t>', ':tabnew<CR>', {desc = "New tab"})
	vim.keymap.set('n', '<D-w>', ':tabclose<CR>', {desc = "Close tab"})
	vim.keymap.set('n', '<D-Left>', ':tabprevious<CR>', {desc = "Previous tab"})
	vim.keymap.set('n', '<D-Right>', ':tabnext<CR>', {desc = "Next tab"})
end

--  Plugin {{{1

-- lspconfig {{{2

local function lsp_on_attach(client, bufnr)
	local function lsp_map(mode, key, fn, desc)
		vim.keymap.set(mode, key, fn, {
			noremap = true,
			silent = true,
			desc = desc,
			buffer = bufnr,
		})
	end

	local function lsp_nmap(key, fn, desc)
		lsp_map('n', key, fn, desc)
	end

	vim.bo.omnifunc =  'v:lua.vim.lsp.omnifunc'

	-- Keybindings
	--  K            Documentation (default)
	--  gd           Go to definition
	--  gD           Go to definition in a vertical split
	lsp_nmap('gd', vim.lsp.buf.definition, "Go to definition")
	lsp_nmap('gD', function()
		vim.cmd [[vsplit]]
		vim.lsp.buf.definition()
	end, "Go to definition (vertical)")

	-- Remap 0.11 built-in mappings to take advantage of Snacks picker
	--
	-- grr  Find references
	-- gri  Find implementations
	-- gO   Show document outline
	lsp_nmap('grr', Snacks.picker.lsp_references, "Find references")
	lsp_nmap('gri', Snacks.picker.lsp_implementations, "Find implementations")
	lsp_nmap('gO', Snacks.picker.lsp_symbols, "Find symbols (document)")

	-- Other defaults:
	--
	-- grn: rename
	-- gra: code action
	-- Ctrl-S: signature help

	-- Mnemonics:
	-- grf  Code format
	lsp_nmap('grf', vim.lsp.buf.format, "Reformat file")
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
	elseif vim.snippet.active({direction = 1}) then
		vim.snippet.jump(1)
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
			vim.snippet.expand(args.body)
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
			elseif vim.snippet.active({direction = -1}) then
				vim.snippet.jump(-1)
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
		{name = 'snippets'},
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
		{name = 'snippets'},
		{name = 'buffer'},
		{name = 'tmux'},
	}),
})

-- netrw {{{2
vim.g.netrw_liststyle = 3

-- Search operator:
-- gs<motion>: Search for text matched by motion in all files.
function grep_operator(kind)
	if kind ~= 'char' then
		print("Can only grep on lines")
		return
	end

	-- (0, 0)-indexed row-col positions
	local start = vim.api.nvim_buf_get_mark(0, '[')
	local stop = vim.api.nvim_buf_get_mark(0, ']')

	-- nvim_buf_get_mark returns (1, 0)-indexed row-col.
	start[1] = start[1] - 1
	stop[1] = stop[1] - 1

	-- If we cross line-wise boundaries, do nothing
	-- since we can't grep across lines.
	if start[1] ~= stop[1] then
		return
	end

	stop[2] = stop[2] + 1 -- get_text is exclusive
	local text = vim.api.nvim_buf_get_text(
		0, start[1], start[2], stop[1], stop[2], {}
	)
	if not text then
		return
	end

	Snacks.picker.grep_word {
		search = text[1],
	}
end

vim.keymap.set('n', 'gs', function()
	vim.o.operatorfunc = "v:lua.grep_operator"
	return 'g@'
end, {desc = "Search", expr = true})


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
	matchup = {
		enable = true,
	},
}


-- trouble {{{2
require('trouble').setup {
	auto_open = false,
	auto_close = true,
	auto_preview = false,

	action_keys = {
		close = "q",
		cancel = "<esc>",
		toggle_preview = "P",
	},

	-- Don't complain if there are no diagnostics.
	warn_no_results = false,
	open_no_results = true,
}

require('lsp_lines').setup()

vim.diagnostic.config({
	virtual_text = false,

	-- Show multi-line diagnostics only for the current line.
	virtual_lines = { only_current_line = true },
})

vim.keymap.set('n', '<leader>xx', ':Trouble diagnostics toggle<cr>', {desc = "Diagnostics list"})
vim.keymap.set('n', '<leader>xl', ':Trouble loclist toggle<cr>', {desc = "Location list"})
vim.keymap.set('n', '<leader>xq', ':Trouble qflist toggle<cr>', {desc = "Quickfix list"})
vim.keymap.set('n', '<leader>xn', function()
	vim.diagnostic.goto_next({float = false, wrap = false})
end, {desc = "Next diagnostic"})

vim.keymap.set('n', '<leader>xN', function()
	vim.diagnostic.goto_prev({float = false, wrap = false})
end, {desc = "Previous diagnostic"})

-- Snacks {{{1

-- :Notifications to view past notifications.
vim.api.nvim_create_user_command('Notifications', function()
	Snacks.notifier.show_history()
end, {desc = "Show past notifications"})

-- Toggle shortcuts {{{2
--
-- All shortcuts preceded by <leader>u.
--
--  x: diagnostics
--  A: copilot
--  z: spell checking
--
--  LSP (l):
--    i: inlay hints
--
--  Git (g):
--    b: current line blame
--    d: show deleted
--    w: word diff
Snacks.toggle.option('spell', {name = 'Spell checking'}):map('<leader>uz')
Snacks.toggle.diagnostics():map('<leader>ux')
Snacks.toggle.inlay_hints():map('<leader>uli')
Snacks.toggle.get('gitsigns_current_line_blame'):map('<leader>ugb')
Snacks.toggle.get('gitsigns_show_deleted'):map('<leader>ugd')
Snacks.toggle.get('gitsigns_word_diff'):map('<leader>ugw')

-- May not be enabled.
local toggle_copilot = Snacks.toggle.get('github_copilot')
if toggle_copilot ~= nil then
	toggle_copilot:map('<leader>uA')
end

--  File Types {{{1

-- rust {{{2
vim.g.rustfmt_autosave = 1
