if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

" ----------------------------------------------------------------------------
"  General Plugins {{{2
" ----------------------------------------------------------------------------
Plug 'cespare/vim-toml'
Plug 'christoomey/vim-tmux-navigator'
Plug 'edkolev/tmuxline.vim'
Plug 'honza/vim-snippets'
Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/molokai'
Plug 'justinmk/vim-sneak'
Plug 'machakann/vim-highlightedyank'
Plug 'mhinz/vim-grepper'
Plug 'ntpeters/vim-better-whitespace'
Plug 'rstacruz/sparkup', {'rtp': 'vim'}
Plug 'scrooloose/nerdtree'
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/vimproc', {'do': 'make'}
Plug 'sickill/vim-pasta'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/visualrepeat'
Plug 'w0rp/ale'

" ----------------------------------------------------------------------------
"  Language-specific Plugins {{{2
" ----------------------------------------------------------------------------
Plug 'vim-scripts/Arduino-syntax-file'
Plug 'davidhalter/jedi-vim', {'for': ['python', 'pyrex']}
Plug 'eagletmt/ghcmod-vim'
Plug 'eagletmt/neco-ghc'
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'garyburd/go-explorer',
  \ {'for': 'go', 'do': 'go get -u github.com/garyburd/go-explorer/src/getool'}
Plug 'hspec/hspec.vim'
Plug 'hynek/vim-python-pep8-indent'
Plug 'idris-hackers/idris-vim'
Plug 'jneen/ragel.vim'
Plug 'pbrisbin/html-template-syntax'
Plug 'rust-lang/rust.vim'
Plug 'sebastianmarkow/deoplete-rust'
Plug 'solarnz/thrift.vim', {'for': 'thrift'}
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-after'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'zchee/deoplete-go', {'do': 'make'}

call plug#end()

" ----------------------------------------------------------------------------
"  Global autocmds {{{1
" ----------------------------------------------------------------------------

augroup vimrc_ft_hooks
    autocmd!
    autocmd FileType c call s:SetupC()
    autocmd FileType cpp call s:SetupCPP()
    autocmd FileType go call s:SetupGo()
    autocmd FileType gitcommit setlocal tw=72
    autocmd FileType haskell,chaskell call s:SetupHaskell()
    autocmd FileType javascript call s:ClosePreviewOnMove()
    autocmd FileType nerdtree setlocal nolist
    autocmd FileType plain setlocal nolist
    autocmd FileType pandoc call s:SetupPandoc()
    autocmd FileType python call s:SetupPython()
    autocmd FileType rust call s:SetupRust()
    autocmd FileType sh call s:SetupSh()
    autocmd FileType text setlocal nornu
    autocmd FileType yaml call s:SetupYAML()

    autocmd BufNewFile,BufRead *.rl setf ragel
    autocmd BufReadPost quickfix call s:SetupQuickfix()
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
    \ 'go': ['go vet', 'golint', 'go build'],
    \ 'haskell': ['stack-ghc-mod'],
    \ }
let g:ale_linter_aliases = {
    \ 'pandoc': ['markdown']
    \ }

"  pandoc {{{2
let g:pandoc#after#modules#enabled = ["neosnippets"]
let g:pandoc#modules#disabled = ["folding"]
let g:pandoc#formatting#mode = "h"
let g:pandoc#formatting#extra_equalprg = "--reference-links --reference-location=section --atx-headers"
let g:pandoc#syntax#conceal#use = 0

" netrw {{{2
let g:netrw_liststyle = 3

" airline {{{2
let g:airline_theme = "molokai"
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#displayed_head_limit = 10
let g:airline#extensions#ale#enabled = 1

" We want to do this manually with,
"   :Tmuxline airline | TmuxlineSnapshot ~/.tmux-molokai.conf
let g:airline#extensions#tmuxline#enabled = 0

" deoplete {{{2
set completeopt=menu,preview,longest
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#go#gocode_binary = $GOPATH . '/bin/gocode'

let g:deoplete#sources#rust#disable_keymap = 1
let g:deoplete#sources#rust#racer_binary = '/Users/abg/.cargo/bin/racer'
if $RUST_SRC_PATH != ''
    let g:deoplete#sources#rust#rust_source_path = $RUST_SRC_PATH
endif

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

" ----------------------------------------------------------------------------
"  General Configuration {{{1
" ----------------------------------------------------------------------------
set nocp                " Don't need compatibility with vi
set nobk                " Don't make backups
set nowb                " Don't make backups before overwrite
set bs=indent,eol,start " Allow backspace over everything
set hi=50               " Keep 50 lines of command line history
set ru                  " Show the cursor position all the time
set rnu                 " Relative line numbering
set nu                  " Absolute line number for current line
set ls=2                " Always show status line
set sc                  " Display incomplete commands
set is                  " Do incremental searching
set ai                  " Keep indentation from previous line
set et                  " Use spaces to insert tabs
set sw=4                " Number of spaces to use for each indent
set ts=4                " Number of spaces tab will count for
set nowrap              " No wrapping
set ic scs              " Smart case insensitive
set icm=split           " Show :s result incrementally
set tc=match            " Case sensitive for tag search
set sta                 " Smart tab
set bg=dark             " We have a dark background
set tw=78               " Wrap text after 78 characters
set lz                  " Lazy redraw; faster macros
set ve=all              " Virtual edit
set vb                  " Use visual bell instead of beeping"
set sb                  " split below
set spr                 " split right
set so=3                " leave 3 lines below cursor
set fdm=marker          " Marker fold method
set hls                 " Highlight search results
set wmnu                " Menu for tab completion
set mouse=a             " Mouse support

" Use true color if not on Terminal.app
if $TERM_PROGRAM != "Apple_Terminal"
    set tgc
endif

" Show invisible characters
set list lcs=tab:»\ ,trail:·

colo molokai

" File patterns to ignore in wildcard expansions.
set wig+=*/cabal-dev,*/dist,*.o,*.class,*.pyc,*.hi

" Support codex tags.
set tags+=codex.tags

" Workaround for https://github.com/neovim/neovim/issues/4210
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
nmap <silent> <leader>ww :Windows<CR>
nmap <silent> <leader>: :Commands<CR>

" Buffer shortcuts
nmap <silent> <leader>q :bd<CR>
nmap <silent> <leader>n :bn<CR>
nmap <silent> <leader>N :bN<CR>

" Window shortcuts
nmap <silent> <leader>wd :close<CR>
nmap <silent> <leader>wns :new<CR>
nmap <silent> <leader>wnv :vnew<CR>
nmap <silent> <leader>ws :split<CR>
nmap <silent> <leader>wv :vsplit<CR>

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

function! s:SetupHaskell() " {{{2
    let g:haskellmode_completion_ghc = 0
    let g:necoghc_enable_detailed_browse = 1
    setlocal omnifunc=necoghc#omnifunc
    setlocal ts=2 sw=2 et

    nmap <buffer> <F1> :GhcModType<CR>
    nmap <buffer> <silent> <F2> :GhcModTypeClear<CR>
    nmap <buffer> <silent> <leader>d <C-w><C-]><C-w>T
endfunction

function! s:SetupC() " {{{2
    call s:ClosePreviewOnMove()
endfunction

function! s:SetupCPP() " {{{2
    call s:ClosePreviewOnMove()
endfunction

function! s:SetupPython() " {{{2
    let b:delimitMate_nesting_quotes = ['"','''', '`']
    call s:ClosePreviewOnMove()
endfunction

function! s:SetupGo() " {{{2
    setlocal noet
    nmap <buffer> <leader>d <Plug>(go-def)

    " Search for declarations in the current file or directory.
    nmap <buffer> <leader>ss :GoDecls<CR>
    nmap <buffer> <leader>sd :GoDeclsDir<CR>

    call s:ClosePreviewOnMove()
endfunction

function! s:SetupSh() " {{{2
    setlocal noet
endfunction

function! s:SetupPandoc() " {{{2
    setlocal nolist
    setlocal nornu
endfunction

function! s:SetupQuickfix() " {{{2
    nnoremap <buffer> <C-O> <C-W><Enter>
    nnoremap <buffer> <C-T> <C-W><Enter><C-W>T
endfunction

function! s:SetupRust() " {{{2
    nmap <buffer> <leader>d <Plug>DeopleteRustGoToDefinitionTab
    nmap <buffer> K <Plug>DeopleteRustShowDocumentation
endfunction

function! s:SetupYAML() " {{{2
    setlocal ts=2 sw=2 et
    augroup vimrc_yaml_hooks
        autocmd!
        autocmd BufWritePost package.yaml silent !hpack --silent
    augroup end
endfunction
