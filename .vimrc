if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

" ----------------------------------------------------------------------------
"  Plugins {{{1
" ----------------------------------------------------------------------------
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
Plug 'cespare/vim-toml'
Plug 'christoomey/vim-tmux-navigator'
Plug 'davidhalter/jedi-vim', {'for': ['python', 'pyrex']}
Plug 'edkolev/tmuxline.vim'
Plug 'fatih/vim-go'
Plug 'honza/vim-snippets'
Plug 'hynek/vim-python-pep8-indent'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/molokai'
Plug 'justinmk/vim-sneak'
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

" ----------------------------------------------------------------------------
"  Global autocmds {{{1
" ----------------------------------------------------------------------------

augroup vimrc_ft_hooks
    autocmd!
    autocmd FileType c call s:SetupC()
    autocmd FileType cpp call s:SetupCPP()
    autocmd FileType go call s:SetupGo()
    autocmd FileType gitcommit setlocal textwidth=72
    autocmd FileType javascript call s:ClosePreviewOnMove()
    autocmd FileType nerdtree setlocal nolist
    autocmd FileType vimwiki call s:SetupVimwiki()
    autocmd FileType bzl,python call s:SetupPython()
    autocmd FileType sh call s:SetupSh()
    autocmd FileType text setlocal norelativenumber
    autocmd FileType yaml call s:SetupYAML()

    autocmd BufReadPost quickfix call s:SetupQuickfix()

    autocmd FileType * call s:SetupLanguageClient()
augroup end

augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup end

" Trigger :checktime when changing buffers or coming back to vim.
augroup AutoReload
    autocmd!
    autocmd FocusGained,BufEnter * :checktime
augroup end

" ----------------------------------------------------------------------------
"  Plugin Configuration {{{1
" ----------------------------------------------------------------------------

" ale {{{2
let g:ale_open_list = 1
let g:ale_sign_error='⊘'
let g:ale_sign_warning='⚠'
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 0
let g:ale_emit_conflict_warnings = 0

let g:ale_linters = {
    \ 'go': ['go vet', 'golint'],
    \ }
let g:ale_linter_aliases = {
    \ 'vimwiki': ['markdown']
    \ }

" netrw {{{2
let g:netrw_liststyle = 3

" airline {{{2
let g:airline_theme = "molokai"
let g:airline#extensions#branch#displayed_head_limit = 10
let g:airline#extensions#ale#enabled = 1

" We want to do this manually with,
"   :Tmuxline airline | TmuxlineSnapshot ~/.tmux-molokai.conf
let g:airline#extensions#tmuxline#enabled = 0

" deoplete {{{2
set completeopt=menu,preview,longest
let g:deoplete#enable_at_startup = 1

" Rust {{{2
let g:rustfmt_autosave = 1

" easy-align {{{2
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Jedi Vim {{{2
let g:jedi#show_call_signatures = 0
let g:jedi#use_tabs_not_buffers = 1

" NERDTree {{{2
let g:NERDTreeMapJumpNextSibling="C-M-J"
let g:NERDTreeMapJumpPrevSibling="C-M-J"

" vim-go {{{2
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

" grepper {{{2
let g:grepper =
    \ {
    \ 'tools': ['rg', 'ag', 'git'],
    \ 'open': 1,
    \ 'switch': 1,
    \ 'jump': 0,
    \ 'dir': 'filecwd',
    \ }

" neosnippets {{{2
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory = "~/.config/nvim/plugged/vim-snippets/snippets"

" fzf {{{2
let g:fzf_layout = { 'down': '~15%' }

" tmux-navigator {{{2
" We have our own mappings
let g:tmux_navigator_no_mappings = 1

" LanguageClient-neovim {{{2
let g:LanguageClient_serverCommands = {
    \ 'go': ['gopls'],
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ }
let g:LanguageClient_rootMarkers = {
    \ 'go': ['go.mod', 'Gopkg.toml', 'glide.lock'],
    \ }
let g:LanguageClient_autoStart = 1

" Disable diagnostics until they're supported onsave only.
" https://github.com/autozimu/LanguageClient-neovim/issues/754
let g:LanguageClient_diagnosticsEnable = 0

" vimwiki {{{2
let s:wiki_defaults =
    \ {
    \   'syntax': 'markdown',
    \   'ext': '.md',
    \   'diary_rel_path': 'log/',
    \   'diary_index': 'index',
    \   'diary_header': 'Log',
    \   'auto_tags': 1,
    \   'auto_diary_index': 1,
    \   'auto_toc': 1,
    \   'list_margin': 0,
    \ }

let s:global_wiki = copy(s:wiki_defaults)
let s:global_wiki.path = '~/.notes'
let g:vimwiki_list = [s:global_wiki]

" Local wiki added first by setting VIMWIKI_PATH.
if $VIMWIKI_PATH != ""
    let s:local_wiki = copy(s:wiki_defaults)
    let s:local_wiki.path = $VIMWIKI_PATH
    call insert(g:vimwiki_list, s:local_wiki)
endif

let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_ext2syntax = {'.md': 'markdown'}
let g:vimwiki_autowriteall = 0
let g:vimwiki_auto_chdir = 1
let g:vimwiki_folding = 'expr'

" taskwiki {{{2
let g:taskwiki_markup_syntax = "markdown"
let g:taskwiki_disable_concealcursor = 1

" ----------------------------------------------------------------------------
"  General Configuration {{{1
" ----------------------------------------------------------------------------
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
    set tgc
endif

colo molokai

" Use terminal background for performance.
hi Normal ctermbg=NONE guibg=NONE

" Make line numbers in terminal more readable
hi LineNr ctermfg=245

" Invisible vertical split
hi VertSplit guibg=bg guifg=bg

" Use global python. Ensures nvim works with Python plugins inside a virtualenv.
let g:python_host_prog = '/usr/local/bin/python'

" Space = leader
let mapleader = "\<Space>"

" ----------------------------------------------------------------------------
"  Key Bindings {{{1
" ----------------------------------------------------------------------------

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

" Better split navigation
nnoremap <silent> <C-J> :TmuxNavigateDown<CR>
nnoremap <silent> <C-K> :TmuxNavigateUp<CR>
nnoremap <silent> <C-L> :TmuxNavigateRight<CR>
nnoremap <silent> <C-H> :TmuxNavigateLeft<CR>

" Easier tabbing
nmap <silent> <C-M-T> :tabe<CR>
nmap <silent> <C-M-H> :tabp<CR>
nmap <silent> <C-M-L> :tabn<CR>

" Disable ex mode from Q
nnoremap Q <Nop>

" Clear highlgihts on enter
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

"  ale
nmap <silent> <leader>ep <Plug>(ale_previous_wrap)
nmap <silent> <leader>en <Plug>(ale_next_wrap)

" fzf
nmap <silent> <C-P> :Files<CR>
nmap <silent> <leader>tt :Trees<CR>
nmap <silent> <leader>r :History<CR>
nmap <silent> <leader>bb :Buffers<CR>
nmap <silent> <leader>: :Commands<CR>

" Buffer shortcuts
nmap <silent> <leader>q :bd<CR>
nmap <silent> <leader>n :bn<CR>
nmap <silent> <leader>N :bN<CR>

" Window shortcuts
nmap <silent> <leader>wd :close<CR>
nmap <silent> <leader>wns :new<CR>
nmap <silent> <leader>wnv :vnew<CR>

" NerdTREE shortcuts
nmap <silent> <leader>tp :NERDTreeToggle<CR>
nmap <silent> <leader>tf :call <sid>ToggleNERDTree()<CR>
nmap <silent> <C-\>      :call <sid>ToggleNERDTree()<CR>

" use sneak f/F t/T
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

"  vim-grepper
if executable('rg')
    nnoremap <leader>g :Grepper -tool rg<cr>
else
    nnoremap <leader>g :Grepper -tool ag<cr>
endif

nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" SuperTab-style behavior
function! s:HandleTab() " {{{2
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

" Auto-completion and snippets
imap <expr><TAB> <SID>HandleTab()
inoremap <silent><expr> <C-Space> deoplete#mappings#manual_complete()

" ----------------------------------------------------------------------------
"  Commands {{{1
" ----------------------------------------------------------------------------

" Fuzzy find a directory and open a NERDTree.
command! Trees call s:FZFDirs({'sink': 'NERDTree'})

" ----------------------------------------------------------------------------
"  Functions {{{1
" ----------------------------------------------------------------------------

" FZFDirs runs FZF, displaying only directories.
function! s:FZFDirs(opts) " {{{2
    let cmd = 'find -L .
                \ \( -path ''*/\.*'' -o -fstype dev -o -fstype proc \) -prune
                \ -o -type d -print | sed 1d | cut -b3-'
    call fzf#run(extend({'source': cmd}, a:opts))
endfunction

" ToggleNERDTree opens a NERDTree in the parent directory of the current file
" or in the current directory if a file isn't open.
function! s:ToggleNERDTree() " {{{2
    if expand('%') == ''
        exec 'NERDTreeToggle'
    else
        exec 'NERDTreeToggle %:h'
    endif
endfunction

function! s:ClosePreview() " {{{2
    if pumvisible() == 0 && bufname('%') != "[Command Line]"
        silent! pclose
    endif
endfunction

" ClosePreviewOnMove sets up an autocmd to close the preview window once the
" cursor moves.
function! s:ClosePreviewOnMove() " {{{2
    autocmd CursorMovedI <buffer> call s:ClosePreview()
    autocmd InsertLeave  <buffer> call s:ClosePreview()
endfunction

" MkNonExDir creates the parent directories for the given file if they don't
" already exist.
function! s:MkNonExDir(file, buf) " {{{2
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction

" ----------------------------------------------------------------------------
"  Language-specific Functions {{{1
" ----------------------------------------------------------------------------

function! s:SetupC() " {{{2
    call s:ClosePreviewOnMove()
endfunction

function! s:SetupCPP() " {{{2
    call s:ClosePreviewOnMove()
endfunction

function! s:SetupPython() " {{{2
    call s:ClosePreviewOnMove()
    setlocal shiftwidth=4 tabstop=4 expandtab
endfunction

function! s:SetupGo() " {{{2
    setlocal noexpandtab

    " Search for declarations in the current file or directory.
    nmap <buffer> <leader>ss :GoDecls<CR>
    nmap <buffer> <leader>sd :GoDeclsDir<CR>

    call s:ClosePreviewOnMove()
endfunction

function! s:SetupLanguageClient() " {{{2
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
    nnoremap <buffer> <silent> <F5> :call LanguageClient_contextMenu()<CR>
endfunction

function! s:SetupSh() " {{{2
    setlocal noexpandtab
endfunction

function! s:SetupVimwiki() " {{{2
    setlocal nolist nonumber norelativenumber
    setlocal shiftwidth=4 tabstop=4 expandtab
    setlocal spell

    " Don't highlight task priority.
    highlight TaskWikiTaskPriority ctermbg=NONE guibg=NONE

    " Shift-Enter doesn't appear to work in iTerm. Use Alt-Enter instead.
    inoremap <A-CR> <Esc>:VimwikiReturn 2 2<CR>
endfunction

function! s:SetupQuickfix() " {{{2
    " Ctrl-O    Open in split.
    " Ctrl-T    Open in tab.

    nnoremap <buffer> <C-O> <C-W><Enter>
    nnoremap <buffer> <C-T> <C-W><Enter><C-W>T
endfunction

function! s:SetupYAML() " {{{2
    setlocal tabstop=2 shiftwidth=2 expandtab
    augroup vimrc_yaml_hooks
        autocmd!
        autocmd BufWritePost package.yaml silent !hpack --silent
    augroup end
endfunction
