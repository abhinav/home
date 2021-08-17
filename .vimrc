if $VIM_PATH != ""
	let $PATH=$VIM_PATH
endif

if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

"  Plugins {{{1
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
Plug 'machakann/vim-highlightedyank'
Plug 'mhinz/vim-grepper'
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-markdown-subscope'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-ultisnips'
Plug 'ntpeters/vim-better-whitespace'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'rbgrouleff/bclose.vim'
Plug 'rhysd/git-messenger.vim'
Plug 'roxma/nvim-yarp'
Plug 'rust-lang/rust.vim'
Plug 'sickill/vim-pasta'
Plug 'SirVer/ultisnips'
Plug 'solarnz/thrift.vim', {'for': 'thrift'}
Plug 'stacked-git/stgit', {'rtp': 'contrib/vim'}
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'voldikss/vim-floaterm', {'do': 'pip install --upgrade neovim-remote'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/visualrepeat'
Plug 'vimwiki/vimwiki'
Plug 'wellle/tmux-complete.vim'
Plug 'dense-analysis/ale'

call plug#end()

"  General {{{1
set nocompatible        " Don't need compatibility with vi.
set nobackup writebackup
                        " Don't backup edited files but temporarily backup
                        " before overwiting.
set backspace=indent,eol,start
set history=50          " History of : commands.
set ruler               " Show the cursor position.
set laststatus=2        " Always show status line.
set showcmd             " Display incomplete commands.
set hidden              " Allow buffers to be hidden without saving.
set relativenumber number
                        " Show the line number of the current line and
                        " relative numbers of all other lines.
set noexpandtab softtabstop=0 shiftwidth=8 tabstop=8
                        " Use 8 tabs for indentation.
set copyindent preserveindent
                        " Preserve existing indentation as much as possible.
set incsearch
set autoindent
set nowrap              " No wrapping
set nojoinspaces        " Don't add two spaces after punctuation when joining
                        " two lines.
set ignorecase smartcase tagcase=followscs
                        " Ignore casing during search except if uppercase
                        " characters are used. Use the same settings for tag
                        " searches.
set shortmess+=c
set inccommand=split    " Show :s result incrementally.
set background=dark
set textwidth=79
set lazyredraw          " Don't redraw the screen while executing macros.
                        " Useful if the macros does a lot of transformation.
set virtualedit=all
set visualbell          " No beeping.
set splitbelow splitright
                        " Split below or to the right of the current window.
set foldmethod=marker
set hlsearch            " Highlight search results.
set wildmenu            " Show options for :-command completion.
set mouse=a             " Support mouse everywhere.
set scrolloff=10        " Lines to leave below cursor when scrolling.
set list listchars=tab:»\ ,trail:·
                        " Show tabs and trailing whitespace.
set wildignore+=*/cabal-dev,*/dist,*.o,*.class,*.pyc,*.hi
                        " Ignore in wildcard expansions.

" Use true color if not on Terminal.app
if $TERM_PROGRAM != "Apple_Terminal"
	set termguicolors
endif

colorscheme molokai

" Make line numbers in terminal more readable
highlight LineNr ctermfg=245

" Invisible vertical split
highlight VertSplit guibg=bg guifg=bg

" Use global python. Ensures nvim works with Python plugins inside a virtualenv.
let g:python_host_prog = '/usr/local/bin/python'

" Space = leader
let mapleader = "\<Space>"

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
let g:ale_open_list = 1
let g:ale_sign_error='⊘'
let g:ale_sign_warning='⚠'
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 0
let g:ale_emit_conflict_warnings = 0
let g:ale_linters = {}
let g:ale_linter_aliases = {}

nmap <silent> <leader>ep <Plug>(ale_previous_wrap)
nmap <silent> <leader>en <Plug>(ale_next_wrap)

" ncm2 {{{2
autocmd BufEnter * call ncm2#enable_for_buffer()

set completeopt=noinsert,menuone,noselect,preview

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
let g:UltiSnipsExpandTrigger            = "<Plug>(ultisnips_expand)"
let g:UltiSnipsJumpForwardTrigger       = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger      = "<c-k>"
let g:UltiSnipsRemoveSelectModeMappings = 0

" easy-align {{{2
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" floaterm {{{2
let g:floaterm_keymap_prev   = '<F4>'
let g:floaterm_keymap_next   = '<F5>'
let g:floaterm_keymap_toggle = '<F9>'
let g:floaterm_autoclose = 1
let g:floaterm_wintype   = 'floating'

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
let g:grepper =
	\ {
	\ 'tools': ['rg', 'ag', 'git'],
	\ 'side': 1,
	\ 'side_cmd': 'new',
	\ 'prompt_text': '$t> ',
	\ 'prompt_quote': 2,
	\ 'quickfix': 1,
	\ 'switch': 1,
	\ 'jump': 0,
	\ 'dir': 'filecwd',
	\ }

" Work around mhinz/vim-grepper#244
let g:grepper.rg = {'grepprg': 'rg -H --no-heading --vimgrep --sort-files $* .'}

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
let g:lens#disabled_filetypes = ['fzf']
let g:lens#disabled_buftypes = ['quickfix']
let g:lens#animate = 0

" markdown-preview {{{2
let g:mkdp_auto_close = 0
let g:mkdp_filetypes = ['markdown', 'vimwiki']

" netrw {{{2
let g:netrw_liststyle = 3

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

" tree-sitter {{{2
lua <<EOF
require'nvim-treesitter.configs'.setup {
	ensure_installed = "maintained", -- install all maintained parsers
	highlight = {enable = true},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
}
EOF


"  File Types {{{1

" go {{{2

" vim-go {{{3
let g:go_def_mapping_enabled = 0
let g:go_code_completion_enabled = 0
let g:go_doc_keywordprg_enabled = 0
let g:go_metalinter_autosave_enabled = []
let g:go_gopls_enabled = 0

let g:go_term_enabled = 1
let g:go_term_reuse = 1
let g:go_term_mode = "split"

let g:go_template_file = $HOME . "/.config/vim-go/main.go"
let g:go_template_test_file = $HOME . "/.config/vim-go/test.go"

if $VIM_GO_BIN_PATH != ""
	let g:go_bin_path = $VIM_GO_BIN_PATH
endif

" ale {{{3
let g:ale_linters.go = []


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
let g:ale_linters.haskell = ['hie', 'stylish-haskell', 'hlint']
let g:ale_haskell_hie_executable = 'hie-wrapper'
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
let g:ale_linters.rust = []

" LanguageClient {{{3
if executable('rust-analyzer')
	let g:LanguageClient_serverCommands.rust = ['rust-analyzer']
else
	let g:LanguageClient_serverCommands.rust = ['rustup', 'run', 'stable', 'rls']
endif

" vimwiki {{{2

function! s:buildWiki(path)
	return {
		\ 'syntax': 'markdown',
		\ 'ext': '.md',
		\ 'auto_toc': 1,
		\ 'list_margin': 0,
		\ 'path': a:path,
		\ }
endfunction

" Use ~/.notes as the wiki location by default. Support overriding by setting
" VIMWIKI_PATH.
let g:vimwiki_list = [s:buildWiki('~/.notes')]
let g:vimwiki_list[0].index = '000000000001 Home'

if $VIMWIKI_PATH != ""
	call insert(g:vimwiki_list, s:buildWiki($VIMWIKI_PATH))
endif

let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_ext2syntax = {'.md': 'markdown'}
let g:vimwiki_autowriteall = 1
let g:vimwiki_auto_chdir = 1
let g:vimwiki_folding = 'expr'
let g:vimwiki_use_mouse = 1
let g:vimwiki_listsyms = ' x'

" ale {{{3
let g:ale_linter_aliases.vimwiki = ['markdown']
