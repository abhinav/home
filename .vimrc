if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

"  Plugins {{{1
Plug 'andymass/vim-matchup'
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
Plug 'camspiers/lens.vim'
Plug 'cappyzawa/starlark.vim'
Plug 'cespare/vim-toml'
Plug 'chrisbra/NrrwRgn'
Plug 'chrisbra/csv.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'direnv/direnv.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'fatih/vim-go'
Plug 'honza/vim-snippets'
Plug 'hynek/vim-python-pep8-indent'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'iberianpig/tig-explorer.vim'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all --no-update-rc'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/molokai'
Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-sneak'
Plug 'kana/vim-operator-user'  " needed for quickhl
Plug 'machakann/vim-highlightedyank'
Plug 'mhinz/vim-grepper'
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-markdown-subscope'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-ultisnips'
Plug 'ntpeters/vim-better-whitespace'
Plug 'ojroques/vim-oscyank'
Plug 'rbgrouleff/bclose.vim'
Plug 'rhysd/git-messenger.vim'
Plug 'roxma/nvim-yarp'
Plug 'rust-lang/rust.vim'
Plug 'SirVer/ultisnips'
Plug 'solarnz/thrift.vim', {'for': 'thrift'}
Plug 'stacked-git/stgit', {'rtp': 'contrib/vim'}
Plug 't9md/vim-quickhl'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'voldikss/vim-floaterm', {'do': 'pip install --upgrade neovim-remote'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/visualrepeat'
Plug 'vim-utils/vim-husk'
Plug 'vimwiki/vimwiki'
Plug 'wellle/tmux-complete.vim'
Plug 'dense-analysis/ale'

call plug#end()

lua << EOF
if vim.env.VIM_PATH then
	vim.env.PATH = vim.env.VIM_PATH
end

-- General {{{1
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
	-- Use global python.
	-- Ensures nvim works with Python plugins inside a virtualenv.
	python_host_prog = '/usr/local/bin/python',

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

" Escape with jk.
inoremap jk <Esc>

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

" Ctrl-P in insert mode will paste while preserving indentation.
inoremap <C-P> <C-R><C-P>"

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
	linter_aliases         = {},
}
EOF

nmap <silent> <leader>ep <Plug>(ale_previous_wrap)
nmap <silent> <leader>en <Plug>(ale_next_wrap)

" ncm2 {{{2
autocmd BufEnter * call ncm2#enable_for_buffer()

inoremap <silent> <C-Space> <c-r>=ncm2#force_trigger()<cr>

" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

" When <CR> is pressed while the popup menu is visible, it only
" hides the menu. This hides the menu and moves on to the next line.
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> <SID>HandleTab()
inoremap <expr> <S-Tab> (pumvisible() ? "\<C-p>" : "\<S-Tab>")

function s:HandleTab()
	" Select the first item if popup is open but nothing has been
	" selected. Otherwise, expand the selected item.
	if pumvisible()
		if empty(v:completed_item)
			return "\<c-n>"
		else
			return ncm2_ultisnips#expand_or("", 'n')
		endif
	endif

	return "\<tab>"
endfunction

" UltiSnips {{{3
imap <c-u> <Plug>(ultisnips_expand)
lua << EOF
let_g('UltiSnips', {
	ExpandTrigger            = "<Plug>(ultisnips_expand)",
	JumpForwardTrigger       = "<c-j>",
	JumpBackwardTrigger      = "<c-k>",
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

" LanguageClient {{{2
let g:LanguageClient_serverCommands = {}
let g:LanguageClient_rootMarkers = {}
let g:LanguageClient_autoStart = 1

" Always show hover preview instead of echoing.
let g:LanguageClient_hoverPreview = "Always"

" Don't wait too long for LSP output.
let g:LanguageClient_waitOutputTimeout = 3

" Don't spam language server. Wait a second before sending updates.
let g:LanguageClient_changeThrottle = 1

" Avoid crash loops.
let g:LanguageClient_restartOnCrash = 0

" Gutter already contains diagnoistc markers. Use virtual text only for
" CodeLens.
let g:LanguageClient_useVirtualText = "CodeLens"

augroup LanguageClientHooks
	autocmd!
	autocmd FileType * call s:SetupLanguageClient()
augroup END

function! s:SetupLanguageClient() " {{{3
	if !has_key(g:LanguageClient_serverCommands, &filetype)
		return
	endif

	" Keybindings
	"  K            Documentation
	"  <leader>d    Go to definition
	"  F2           Rename
	"  Ctrl-Space   Code action
	"  Alt-Enter    Context Menu

	nmap <buffer> <silent> K         <Plug>(lcn-hover)
	nmap <buffer> <silent> <leader>d <Plug>(lcn-definition)
	nmap <buffer> <silent> <F1>      <Plug>(lcn-rename)
	nmap <buffer> <silent> <M-CR>    <Plug>(lcn-menu)
	nmap <buffer> <silent> <C-Space> <Plug>(lcn-code-action)
	vmap <buffer> <silent> <C-Space> <Plug>(lcn-code-action)
endfunction

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

" markdown-preview {{{2
lua <<EOF
let_g('mkdp_', {
	auto_close = 0,
	filetypes = {'markdown', 'vimwiki'},
})
EOF

" netrw {{{2
let g:netrw_liststyle = 3

" oscyank {{{2

" Set up a hook to send an OSC52 code if the system register is used.
augroup OSCHook
	autocmd!

	autocmd TextYankPost * call s:SendOSC52(v:event)
augroup END

function! s:SendOSC52(event) " {{{3
	if a:event.operator is 'y' && a:event.regname is '+'
		OSCYankReg +
	endif
endfunction

" quickhl {{{2

" <leader>m: highlight current word
" <leader>h<motion>: highlight text selected by motion
" <leader>M: clear

nmap <leader>m <Plug>(quickhl-manual-this)
map <leader>h <Plug>(operator-quickhl-manual-this-motion)

nmap <leader>M <Plug>(quickhl-manual-reset)
xmap <leader>M <Plug>(quickhl-manual-reset)

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

" tmux-navigator {{{2

" We have our own mappings
let g:tmux_navigator_no_mappings = 1

" Better split navigation
nnoremap <silent> <C-J> :TmuxNavigateDown<CR>
nnoremap <silent> <C-K> :TmuxNavigateUp<CR>
nnoremap <silent> <C-L> :TmuxNavigateRight<CR>
nnoremap <silent> <C-H> :TmuxNavigateLeft<CR>

"  File Types {{{1

" go {{{2

" vim-go {{{3
lua <<EOF
let_g('go_', {
	def_mapping_enabled = 0,
	code_completion_enabled = 0,
	doc_keywordprg_enabled = 0,
	metalinter_autosave_enabled = {},
	gopls_enabled = 0,
	term_enabled = 1,
	term_reuse = 1,
	term_mode = "split",
	template_file = vim.env.HOME .. "/.config/vim-go/main.go",
	template_test_file = vim.env.HOME .. "/.config/vim-go/test.go",
})

if vim.env.VIM_GO_BIN_PATH then
	vim.g.go_bin_path = vim.env.VIM_GO_BIN_PATH
end
EOF

" ale {{{3
lua ale.linters.go = {}

" Disable gopls if in diff mode or if explicitly disabled.
if $VIM_GOPLS_DISABLED || &diff
	let g:LanguageClient_autoStart = 0
endif

" LanguageClient {{{3
let g:LanguageClient_serverCommands.go =
	\ {
	\ 'name': 'gopls',
	\ 'command': ['gopls', '-remote=auto'],
	\ 'initializationOptions':
		\ {
		\ 'gofumpt': v:true,
		\ 'staticcheck': v:true,
		\ }
	\ }
let g:LanguageClient_rootMarkers.go = ['go.mod', 'Gopkg.toml', 'glide.lock']

" haskell {{{2

" LanguageClient {{{3
lua << EOF
ale.linters.haskell = {'hie', 'stylish-haskell', 'hlint'}
ale.haskell_hie_executable = 'hie-wrapper'
EOF
let g:LanguageClient_serverCommands.haskell = ['hie-wrapper']
let g:LanguageClient_rootMarkers.haskell = ['*.cabal', 'stack.yaml']

" python {{{2

" LanguageClient {{{3
if executable('pyls')
	let g:LanguageClient_serverCommands.python = ['pyls']
endif

" rust {{{2
let g:rustfmt_autosave = 1

" ale {{{3
lua ale.linters.rust = {}

" LanguageClient {{{3
if executable('rust-analyzer')
	let g:LanguageClient_serverCommands.rust = ['rust-analyzer']
else
	let g:LanguageClient_serverCommands.rust = ['rustup', 'run', 'stable', 'rls']
endif

" vimwiki {{{2

lua <<EOF
-- accepts an optional table of options.
local function buildWiki(path, opts)
	opts = opts or {}
	return vim.tbl_extend('force', {
		syntax      = 'markdown',
		ext         = '.md',
		auto_toc    = 1,
		list_margin = 0,
		path        = path,
	}, opts)
end

-- Use ~/.notes as the wiki location by default.
local vimwiki_list = {
	buildWiki('~/.notes', {
		index = '000000000001 Home',
	}),
}

-- Support overriding by setting VIMWIKI_PATH.
if vim.env.VIMWIKI_PATH then
	table.insert(vimwiki_list, 1, buildWiki(vim.env.VIMWIKI_PATH))
end

let_g('vimwiki_', {
	list          = vimwiki_list,
	hl_headers    = 1,
	hl_cb_checked = 1,
	ext2syntax    = {['.md'] = 'markdown'},
	autowriteall  = 1,
	auto_chdir    = 1,
	folding       = 'expr',
	use_mouse     = 1,
	listsyms      = ' x',
})
EOF

" ale {{{3
lua ale.linter_aliases.vimwiki = {'markdown'}

" After {{{1

" ale {{{2
lua let_g('ale_', ale)
