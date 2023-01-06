lua require('plugins')

" General {{{1
lua << EOF

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

let_g {
	mapleader = ' ', -- space = leader
}
EOF

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

" Edit the local vimrc
nnoremap <silent> <leader>evf :tabe $MYVIMRC<cr>
nnoremap <silent> <leader>svf :source $MYVIMRC<cr>

" Buffer shortcuts
nmap <silent> <leader>q :bd<CR>
nmap <silent> <leader>Q :bd!<CR>
nmap <silent> <leader>bn :bn<CR>
nmap <silent> <leader>bN :bN<CR>

" Don't show line numbers in terminal.
autocmd TermOpen * setlocal nonu nornu

" Auto-reload files {{{2

" Trigger :checktime when changing buffers or coming back to vim.
augroup AutoReload
	autocmd!
	autocmd FocusGained,BufEnter * :checktime
augroup end

lua <<EOF
-- Neovide {{{2
if vim.g.neovide then
	vim.opt.guifont = "Iosevka Term:h10"
	let_g('neovide_', {
		cursor_animation_length = 0,
	})
end
EOF

"  Plugin {{{1

" airline {{{2
let g:airline_theme = "molokai"
let g:airline#extensions#branch#displayed_head_limit = 10
let g:airline#extensions#ale#enabled = 1

" We want to do this manually with,
"   :Tmuxline airline | TmuxlineSnapshot ~/.tmux-molokai.conf
let g:airline#extensions#tmuxline#enabled = 0

" ale {{{2
lua <<EOF
ale = {
	open_list              = 1,
	sign_error             = '⊘',
	sign_warning           = '⚠',
	lint_on_save           = 1,
	lint_on_enter          = 0,
	lint_on_text_changed   = 0,
	emit_conflict_warnings = 0,
	linters                = {},
}
EOF

nmap <silent> <leader>ep <Plug>(ale_previous_wrap)
nmap <silent> <leader>en <Plug>(ale_next_wrap)

" nvim-cmp {{{2
lua << EOF
local cmp = require 'cmp'

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local handleTab = function(fallback)
	if cmp.visible() then
		if cmp.get_selected_entry() ~= nil then
			cmp.confirm()
		else
			cmp.select_next_item()
		end
	elseif vim.fn['UltiSnips#CanJumpForwards']() == 1 then
		feedkey("<Plug>(ultisnips_jump_forward)", "")
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
				feedkey("<Plug>(ultisnips_jump_backward)", "")
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
EOF

" UltiSnips {{{3
imap <c-u> <Plug>(ultisnips_expand)
lua << EOF
let_g('UltiSnips', {
	ExpandTrigger            = "<Plug>(ultisnips_expand)",
	JumpForwardTrigger       = "<Plug>(ultisnips_jump_forward)",
	JumpBackwardTrigger      = "<Plug>(ultisnips_jump_backward)",
	ListSnippets             = "<c-x><c-s>",
	RemoveSelectModeMappings = 0,
})
EOF

" easy-align {{{2
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" floaterm {{{2
lua <<EOF
let_g('floaterm_', {
	keymap_prev   = '<F4>',
	keymap_next   = '<F5>',
	keymap_toggle = '<F9>',
	autoclose     = 1,
	wintype       = 'floating',
})
EOF

nnoremap <silent> <F6> :FloatermNew --height=0.4 --width=0.98 --cwd=<buffer> --position=bottom<CR>
tnoremap <silent> <F6> <C-\><C-n>:FloatermNew --height=0.4 --width=0.98 --cwd=<buffer> --position=bottom<CR>
tnoremap <silent> <F7> <C-\><C-n>

" :NNN for nnn
if executable('nnn')
	command! NNN FloatermNew nnn
endif

" fzf {{{2
let g:fzf_layout = { 'down': '~15%' }

nmap <silent> <C-P> :Files<CR>
nmap <silent> <leader>tt :Trees<CR>
nmap <silent> <leader>r :History<CR>
nmap <silent> <leader>bb :Buffers<CR>
nmap <silent> <leader>: :Commands<CR>

" :Trees support {{{3

" FZFDirs runs FZF, displaying only directories.
function! s:FZFDirs(opts) " {{{4
	let cmd = 'find -L .
		\ \( -path ''*/\.*'' -o -fstype dev -o -fstype proc \) -prune
		\ -o -type d -print | sed 1d | cut -b3-'
	call fzf#run(extend({'source': cmd}, a:opts))
endfunction

" Fuzzy find a directory and open a directory.
command! Trees call s:FZFDirs({'sink': 'edit'})

" grepper {{{2
lua <<EOF
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
}
EOF

if executable('rg')
	nnoremap <leader>gg :Grepper -tool rg<cr>
else
	nnoremap <leader>gg :Grepper -tool ag<cr>
endif

nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" lspconfig {{{2
lua << EOF
local nvim_lsp = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

function setup_lsp(server, lsp_opts)
	lsp_opts.on_attach = function(client, bufnr)
		local function buf_set_keymap(...)
			vim.api.nvim_buf_set_keymap(bufnr, ...)
		end

		local function buf_set_option(...)
			vim.api.nvim_buf_set_option(bufnr, ...)
		end

		buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
		local opts = { noremap = true, silent = true }

		-- Keybindings
		--  K            Documentation
		--  <leader>d    Go to definition
		--  F2           Rename
		--  Alt-Enter    Code action

		buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
		buf_set_keymap('n', '<leader>d', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
		buf_set_keymap('n', '<F1>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
		buf_set_keymap('n', '<M-CR>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
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
EOF

" lens {{{2
lua <<EOF
let_g('lens#', {
	disabled_filetypes = {'fzf'},
	disabled_buftypes  = {'quickfix'},
	animate            = 0,
})
EOF

" matchup {{{2
lua <<EOF
let_g('matchup_', {
	matchparen_offscreen = {
		method = 'popup',
	},
})
EOF

" Map z% to something else, leaving 'z' free for vim-sneak.
nmap <nop> <plug>(matchup-z%)
xmap <nop> <plug>(matchup-z%)
omap <nop> <plug>(matchup-z%)

" markdown-preview {{{2
lua <<EOF
let_g('mkdp_', {
	auto_close = 0,
	filetypes = {'markdown'},
})
EOF

" netrw {{{2
let g:netrw_liststyle = 3

" oscyank {{{2
lua <<EOF

let_g('oscyank_', {
	-- https://github.com/ojroques/vim-oscyank/issues/26#issuecomment-1179722561
	term = 'default',
})

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
EOF

" registers {{{2

lua <<EOF
local registers = require('registers')
registers.setup {
	hide_only_whitespace = 1,
	window = {border = 'shadow'},
	show_empty = false,
	bind_keys = {
		normal = registers.show_window({mode = "motion", delay = 0.5}),
		visual = registers.show_window({mode = "motion", delay = 0.5}),
		insert = registers.show_window({mode = "insert", delay = 0.5}),
	},
}
EOF

" sneak {{{2
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
omap t <Plug>Sneak_t
omap T <Plug>Sneak_T

" tree-sitter {{{2
lua << EOF
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
}
EOF

" tmux-navigator {{{2

" We have our own mappings
let g:tmux_navigator_no_mappings = 1

" Better split navigation
nnoremap <silent> <C-J> :TmuxNavigateDown<CR>
nnoremap <silent> <C-K> :TmuxNavigateUp<CR>
nnoremap <silent> <C-L> :TmuxNavigateRight<CR>
nnoremap <silent> <C-H> :TmuxNavigateLeft<CR>

" trouble {{{2
lua << EOF
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

	-- Non-patched font:
	fold_open = "▼",
	fold_closed = "▶",
	icons = false,
	padding = false,
	indent_lines = false,
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
EOF

" vim-visual-multi {{{2
lua << EOF
let_g('VM_', {
	maps = {
		['Add Cursor Down'] = '<M-S-j>',
		['Add Cursor Up'] = '<M-S-k>',
	},
})
EOF

" vim-test {{{2
lua << EOF
let_g({
	['test#strategy'] = 'neovim',
})
EOF

"  File Types {{{1

" go {{{2

" ale {{{3
lua ale.linters.go = {}

" lsp {{{3
lua << EOF
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
EOF

" haskell {{{2

" lsp {{{3
lua << EOF
ale.linters.haskell = {'hie', 'stylish-haskell', 'hlint'}
ale.haskell_hie_executable = 'hie-wrapper'
EOF

" markdown {{{2
lua << EOF
let_g('pandoc#syntax#', {
	['conceal#use'] = 0,
})
EOF

" rust {{{2
let g:rustfmt_autosave = 1

" ale {{{3
lua ale.linters.rust = {}

" lsp {{{3
lua << EOF
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
EOF

" typescript {{{2

" lsp {{{3
lua <<EOF
setup_lsp('tsserver', {
	init_options = {
		disableAutomaticTypingAcquisition = true,
	},
})
EOF

" wiki.vim {{{2
lua <<EOF
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
EOF

" After {{{1

" ale {{{2
lua let_g('ale_', ale)
