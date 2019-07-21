if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

"  Plugins {{{1
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
Plug 'cespare/vim-toml'
Plug 'christoomey/vim-tmux-navigator'
Plug 'davidhalter/jedi-vim', {'for': ['python', 'pyrex']}
Plug 'edkolev/tmuxline.vim'
Plug 'fatih/vim-go'
Plug 'honza/vim-snippets'
Plug 'hynek/vim-python-pep8-indent'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all --no-update-rc'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/molokai'
Plug 'justinmk/vim-sneak'
Plug 'mattn/calendar-vim'
Plug 'machakann/vim-highlightedyank'
Plug 'mhinz/vim-grepper'
Plug 'ntpeters/vim-better-whitespace'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree'
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/vimproc', {'do': 'make'}
Plug 'sickill/vim-pasta'
Plug 'solarnz/thrift.vim', {'for': 'thrift'}
Plug 'tbabej/taskwiki', {'do': 'pip3 install --upgrade git+git://github.com/tbabej/tasklib@develop'}
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/visualrepeat'
Plug 'vimwiki/vimwiki'
Plug 'w0rp/ale'

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
set ignorecase smartcase tagcase=followscs
                        " Ignore casing during search except if uppercase
                        " characters are used. Use the same settings for tag
                        " searches.
set inccommand=split    " Show :s result incrementally.
set background=dark
set textwidth=78
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

" Use terminal background for performance.
highlight Normal ctermbg=NONE guibg=NONE

" Make line numbers in terminal more readable
highlight LineNr ctermfg=245

" Invisible vertical split
highlight VertSplit guibg=bg guifg=bg

" Use global python. Ensures nvim works with Python plugins inside a virtualenv.
let g:python_host_prog = '/usr/local/bin/python'

" Space = leader
let mapleader = "\<Space>"

" Configuration available on OSX only:
if has("unix")
	let s:uname = system("uname")
	if s:uname == "Darwin"
		set macmeta        " Use Option key as Meta
		set fuopt=maxvert  " Don't change width in OSX full screen mode
	endif
endif

" If using gnome-terminal, use 256 colors.
if $COLORTERM == 'gnome-terminal'
	set t_Co=256
endif

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
nmap <silent> <leader>n :bn<CR>
nmap <silent> <leader>N :bN<CR>

" SuperTab-style behavior {{{2

" Auto-completion and snippets
imap <expr><TAB> <SID>HandleTab()

function! s:HandleTab() " {{{3
	if neosnippet#expandable_or_jumpable()
		return "\<Plug>(neosnippet_expand_or_jump)"
	else
		if pumvisible()
			return "\<c-n>"
		else
			return "\<tab>"
		endif
	endif
endfunction

" Close Preview on Move {{{2

" ClosePreviewOnMove sets up an autocmd to close the preview window once the
" cursor moves.
function! s:ClosePreviewOnMove() " {{{3
	autocmd CursorMovedI <buffer> call s:ClosePreview()
	autocmd InsertLeave  <buffer> call s:ClosePreview()
endfunction

function! s:ClosePreview() " {{{3
	if pumvisible() == 0 && bufname('%') != "[Command Line]"
		silent! pclose
	endif
endfunction


" Automatic directory creation {{{2

augroup BWCCreateDir " {{{3
	autocmd!
	autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup end

" MkNonExDir creates the parent directories for the given file if they don't
" already exist.
function! s:MkNonExDir(file, buf) " {{{3
	if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
		let dir=fnamemodify(a:file, ':h')
		if !isdirectory(dir)
			call mkdir(dir, 'p')
		endif
	endif
endfunction

" Clear the group so we can add commands to it.
augroup FileTypeHooks
	autocmd!
augroup end

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

" deoplete {{{2
set completeopt=menu,preview,longest
let g:deoplete#enable_at_startup = 1
inoremap <silent><expr> <C-Space> deoplete#mappings#manual_complete()

" easy-align {{{2
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

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

" Fuzzy find a directory and open a NERDTree.
command! Trees call s:FZFDirs({'sink': 'NERDTree'})

" grepper {{{2
let g:grepper =
	\ {
	\ 'tools': ['rg', 'ag', 'git'],
	\ 'open': 1,
	\ 'switch': 1,
	\ 'jump': 0,
	\ 'dir': 'filecwd',
	\ }

if executable('rg')
	nnoremap <leader>g :Grepper -tool rg<cr>
else
	nnoremap <leader>g :Grepper -tool ag<cr>
endif

nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" LanguageClient {{{2
let g:LanguageClient_serverCommands = {}
let g:LanguageClient_rootMarkers = {}
let g:LanguageClient_autoStart = 1

" Disable diagnostics until they're supported onsave only.
" https://github.com/autozimu/LanguageClient-neovim/issues/754
let g:LanguageClient_diagnosticsEnable = 0

autocmd FileTypeHooks FileType * call s:SetupLanguageClient()

function! s:SetupLanguageClient() " {{{3
	if !has_key(g:LanguageClient_serverCommands, &filetype)
		return
	endif

	" Keybindings
	"  K            Documentation
	"  <leader>d    Go to definition
	"  F2           Rename
	"  F5           Context menu

	nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>
	nnoremap <buffer> <silent> <leader>d :call LanguageClient#textDocument_definition()<CR>
	nnoremap <buffer> <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
	nnoremap <buffer> <silent> <C-Space> :call LanguageClient_contextMenu()<CR>
endfunction

" neosnippets {{{2
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory = "~/.config/nvim/plugged/vim-snippets/snippets"

" NERDTree {{{2
let g:NERDTreeMapJumpNextSibling="C-M-J"
let g:NERDTreeMapJumpPrevSibling="C-M-J"

autocmd FileTypeHooks FileType nerdtree setlocal nolist

nmap <silent> <leader>tp :NERDTreeToggle<CR>
nmap <silent> <leader>tf :call <sid>ToggleNERDTree()<CR>
nmap <silent> <C-\>      :call <sid>ToggleNERDTree()<CR>

" ToggleNERDTree opens a NERDTree in the parent directory of the current file
" or in the current directory if a file isn't open.
function! s:ToggleNERDTree() " {{{3
	if expand('%') == ''
		exec 'NERDTreeToggle'
	else
		exec 'NERDTreeToggle %:h'
	endif
endfunction

" netrw {{{2
let g:netrw_liststyle = 3

" quickfix {{{2
autocmd FileTypeHooks BufReadPost quickfix call s:SetupQuickfix()

function! s:SetupQuickfix() " {{{3
	" Ctrl-O    Open in split.
	" Ctrl-T    Open in tab.
	nnoremap <buffer> <C-O> <C-W><Enter>
	nnoremap <buffer> <C-T> <C-W><Enter><C-W>T
endfunction
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

" taskwiki {{{2
let g:taskwiki_markup_syntax = "markdown"
let g:taskwiki_disable_concealcursor = 1

" tmux-navigator {{{2

" We have our own mappings
let g:tmux_navigator_no_mappings = 1

" Better split navigation
nnoremap <silent> <C-J> :TmuxNavigateDown<CR>
nnoremap <silent> <C-K> :TmuxNavigateUp<CR>
nnoremap <silent> <C-L> :TmuxNavigateRight<CR>
nnoremap <silent> <C-H> :TmuxNavigateLeft<CR>

"  File Types {{{1

" c {{{2

augroup FileTypeHooks
	autocmd FileType c call s:SetupC()
	autocmd FileType cpp call s:SetupC()
augroup end

function! s:SetupC() " {{{3
	call s:ClosePreviewOnMove()
endfunction

" gitcommit {{{2
autocmd FileTypeHooks FileType gitcommit setlocal textwidth=72

" go {{{2

autocmd FileTypeHooks FileType go call s:SetupGo()

function! s:SetupGo() " {{{3
	" Search for declarations in the current file or directory.
	nmap <buffer> <leader>ss :GoDecls<CR>
	nmap <buffer> <leader>sd :GoDeclsDir<CR>
	call s:ClosePreviewOnMove()
endfunction

" vim-go {{{3
let g:go_def_mapping_enabled = 0
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_term_enabled = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_chan_whitespace_error = 0
let g:go_highlight_space_tab_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_snippet_engine = "neosnippet"

" LanguageClient {{{3
let g:LanguageClient_serverCommands.go = ['gopls']
let g:LanguageClient_rootMarkers.go = ['go.mod', 'Gopkg.toml', 'glide.lock']

" ale {{{3
let g:ale_linters.go = ['go vet', 'golint']

" javascript {{{2
autocmd FileTypeHooks FileType javascript call s:ClosePreviewOnMove()

" plain {{{2
autocmd FileTypeHooks FileType text setlocal norelativenumber

" python {{{2

autocmd FileTypeHooks FileType bzl,python call s:SetupPython()

function! s:SetupPython() " {{{3
	call s:ClosePreviewOnMove()
	setlocal shiftwidth=4 tabstop=4 expandtab
endfunction

" jedi-vim {{{3
let g:jedi#show_call_signatures = 0
let g:jedi#use_tabs_not_buffers = 1


" rust {{{2
let g:rustfmt_autosave = 1

" LanguageClient {{{3
let g:LanguageClient_serverCommands.rust = ['rustup', 'run', 'nightly', 'rls']

" vimwiki {{{2

function! s:buildWiki(path)
	return {
		\ 'syntax': 'markdown',
		\ 'ext': '.md',
		\ 'diary_rel_path': 'log/',
		\ 'diary_index': 'index',
		\ 'diary_header': 'Log',
		\ 'auto_tags': 1,
		\ 'auto_diary_index': 1,
		\ 'auto_toc': 1,
		\ 'list_margin': 0,
		\ 'path': a:path,
		\ }
endfunction

" Use ~/.notes as the wiki location by default. Support overriding by setting
" VIMWIKI_PATH.
let g:vimwiki_list = [s:buildWiki('~/.notes')]
if $VIMWIKI_PATH != ""
	call insert(g:vimwiki_list, s:buildWiki($VIMWIKI_PATH))
endif

let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_ext2syntax = {'.md': 'markdown'}
let g:vimwiki_autowriteall = 0
let g:vimwiki_auto_chdir = 1
let g:vimwiki_folding = 'expr'
let g:vimwiki_use_mouse = 1

" Backspace to go back is annoying when mistyped.
nmap <Nop> <Plug>VimwikiGoBackLink

autocmd FileTypeHooks FileType vimwiki call s:SetupVimwiki()

function! s:SetupVimwiki() " {{{3
	setlocal nolist nonumber norelativenumber
	setlocal shiftwidth=4 tabstop=4 expandtab
	setlocal spell foldlevel=1

	" Don't highlight task priority.
	highlight TaskWikiTaskPriority ctermbg=NONE guibg=NONE
endfunction

" Memos {{{3

" mn starts a new memo.
nmap <silent> <leader>mn :call <SID>NewMemo()<CR>

" mf creates a new memo, using the motion to get its title.
nmap <silent> <leader>mf :set opfunc=<SID>NewMemo<CR>g@

" mf in visual mode creates a memo using the selected text as the title.
vmap <silent> <leader>mf :<C-U>call <SID>NewMemo(visualmode())<CR>

" Starts a new numbered memo in the current wiki's root or the default one if
" a wiki isn't open.
"
" Accepts an optional title for the note. Without a title, the cursor will be
" positioned in place to fill the title. Otherwise, the cursor will be
" positioned at the start of the body of the memo.
function! s:NewMemo(...)
	" If invoked as an operator (via a motion), the ranged-over text will
	" be the title.
	let title = ''
	if a:0
		if a:1 != 'char' && a:1 != 'v'
			echoerr 'Only single-line (charwise) ranges can'.
				\ ' be used to create titles.'
			return
		endif

		let [startline, startcol] = getpos(a:1 == 'v' ? "'<" : "'[")[1:2]
		let [endline, endcol] = getpos(a:1 == 'v' ? "'>" : "']")[1:2]
		if startline != endline
			echoerr 'Only single-line (charwise) ranges can'.
				\ ' be used to create titles.'
			return
		endif

		let title = trim(getline(startline)[startcol-1:endcol-1])

		" TODO: If we're in a wiki file, use the vimwiki#path#relpath
		" to replace the ranged text with [$text]($link).
	endif

	let memo_name = strftime('%y%m%d%H%M')

	" If we have a registerted wiki open, the new note will be created
	" relative to its root. Otherwise the default wiki will be used.
	let wiki_nr = vimwiki#vars#get_bufferlocal('wiki_nr')
	if wiki_nr == -1 || vimwiki#vars#get_wikilocal('is_temporary_wiki', wiki_nr)
		let wiki_nr = 0
	endif
	let wiki_index = vimwiki#vars#get_wikilocal('path', wiki_nr) . '/index.md'

	let link = vimwiki#base#resolve_link(memo_name, wiki_index)
	let already_exists = !empty(glob(link.filename))

	call vimwiki#base#open_link(':e ', memo_name, wiki_index)

	if already_exists
		return
	endif

	" This is a new file. Add the template and reposition the cursor.

	call append(line('1'),
		\ [
		\ '---',
		\ printf('title: %s', title),
		\ printf('date: %s', strftime('%Y-%m-%d %H:%M')),
		\ '---',
		\ '',
		\ ])

	" If no title was given, move cursor in position to write the title.
	" Otherwise, move to the body of the note.
	if title == ''
		exec 2
	else
		exec 'normal G'
	endif

	startinsert!
endfunction

" ale {{{3
let g:ale_linter_aliases.vimwiki = ['markdown']

" yaml {{{2
autocmd FileTypeHooks FileType yaml call s:SetupYAML()

function! s:SetupYAML() " {{{3
	setlocal tabstop=2 shiftwidth=2 expandtab
	augroup vimrc_yaml_hooks
		autocmd!
		autocmd BufWritePost package.yaml silent !hpack --silent
	augroup end
endfunction
