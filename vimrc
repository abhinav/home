if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/bundle')

" ----------------------------------------------------------------------------
"  General Plugins {{{2
" ----------------------------------------------------------------------------
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular', {'on': 'Tabularize'}
Plug 'honza/vim-snippets'
Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tomasr/molokai'
Plug 'rizzatti/dash.vim', {'on': 'DashSearch'}
Plug 'rstacruz/sparkup', {'rtp': 'vim'}
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'Shougo/vimproc', {'do': 'make'}
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'Valloric/YouCompleteMe',
  \ {'do': './install.py --clang-completer --gocode-completer --tern-completer --racer-completer'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" ----------------------------------------------------------------------------
"  Language-specific Plugins {{{2
" ----------------------------------------------------------------------------
Plug 'davidhalter/jedi-vim', {'for': ['python', 'pyrex']}
Plug 'eagletmt/ghcmod-vim'
Plug 'eagletmt/neco-ghc'
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'hspec/hspec.vim'
Plug 'hynek/vim-python-pep8-indent'
Plug 'idris-hackers/idris-vim'
Plug 'pbrisbin/html-template-syntax'
Plug 'rust-lang/rust.vim'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-after'
Plug 'vim-pandoc/vim-pandoc-syntax'

call plug#end()

" ----------------------------------------------------------------------------
"  File type hooks {{{1
" ----------------------------------------------------------------------------

au FileType c call s:setup_c()
au FileType cpp call s:setup_cpp()
au FileType go call s:setup_go()
au FileType haskell,chaskell call s:setup_haskell()
au FileType javascript call s:close_preview_on_move()
au FileType pandoc call s:setup_pandoc()
au FileType python call s:setup_python()
au FileType rust call s:setup_rust()
au FileType sh call s:setup_sh()
au FileType text setlocal nornu
au FileType yaml call s:setup_yaml()

augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup end

" ----------------------------------------------------------------------------
"  Plugin Configuration {{{1
" ----------------------------------------------------------------------------

"  pandoc {{{2
let g:pandoc#after#modules#enabled = ["ultisnips"]
let g:pandoc#modules#disabled = ["folding"]
let g:pandoc#formatting#mode = "h"
let g:pandoc#syntax#conceal#use = 0

"  syntastic {{{2
let g:syntastic_aggregate_errors = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_c_config_file = '.clang_complete'
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_config_file = '.clang_complete'
let g:syntastic_enable_signs = 1

let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_go_checkers = ['go', 'golint', 'govet', 'errcheck']

" netrw {{{2
let g:netrw_liststyle = 3

" airline {{{2
let g:airline_theme = "dark"
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#displayed_head_limit = 10

"  Ack.vim {{{2
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

" Rust {{{2
let g:rustfmt_autosave = 1

" Jedi Vim {{{2
let g:jedi#show_call_signatures = 0
let g:jedi#use_tabs_not_buffers = 1

" NERDTree {{{2
let g:NERDTreeMapJumpNextSibling="C-M-J"
let g:NERDTreeMapJumpPrevSibling="C-M-J"

" vim-go {{{2
let g:go_def_mapping_enabled = 0
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_term_enabled = 1
let g:go_alternate_mode = "vsplit"

" fzf {{{2
nmap <silent> <C-P> :Files<CR>
let g:fzf_layout = { 'down': '~15%' }

" YouCompleteMe {{{2
let g:ycm_extra_conf_globlist = ['~/dev/*','!~/*']
let g:ycm_goto_buffer_command = 'new-tab'
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']

" SuperTab {{{2
let g:SuperTabDefaultCompletionType = '<C-n>'
let g:SuperTabNoCompleteAfter = ['^', '\s', '[^\w]']

" UltiSnips {{{2
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Molokai {{{2

let g:molokai_original = 1
let g:rehash256 = 1

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
set ic                  " Case insensitive
set sta                 " Smart tab
set bg=dark             " We have a dark background
set tw=78               " Wrap text after 78 characters
set vb                  " Use visual bell instead of beeping"
set sb                  " split below
set spr                 " split right
set fdm=marker          " Marker fold method
set hls                 " Highlight search results
set wmnu                " Menu for tab completion
colo molokai            " Use molokai

" File patterns to ignore in wildcard expansions.
set wig+=*/cabal-dev,*/dist,*.o,*.class,*.pyc,*.hi

" Support codex tags.
set tags+=codex.tags

" Only bold out the current line
hi CursorLine term=bold cterm=bold

" Make line numbers in terminal more readable
hi LineNr ctermfg=245

" Use global python. Ensures nvim works with Python plugins inside a virtualenv.
let g:python_host_prog = '/usr/local/bin/python'


" Highlight the current line, but only in the focused split.
autocmd WinEnter * setlocal cul
autocmd BufEnter * setlocal cul
autocmd WinLeave * setlocal nocul
setlocal cul

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

" Use Ctrl-Space for omni completion.
if has("gui_running")
    inoremap <C-Space> <C-x><C-o>
else
    if has("unix")
        inoremap <Nul> <C-x><C-o>
    endif
endif

" Better split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Easier tabbing
nmap <silent> <C-M-T> :tabe<CR>
nmap <silent> <C-M-H> :tabp<CR>
nmap <silent> <C-M-L> :tabn<CR>

" Disable ex mode from Q
nnoremap Q <Nop>

" Clear highlgihts on enter
nnoremap <silent> <CR> :nohlsearch<CR><CR>

" Nerd tree on C-m
nmap <C-\> :NERDTreeToggle<CR>

" Dash search on \D
nmap <silent> <leader>D <Plug>DashSearch

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
nnoremap <leader>evf :tabe $MYVIMRC<cr>
nnoremap <leader>evl :tabe ~/.dotfiles/local/vimrc<cr>
nnoremap <leader>svf :source $MYVIMRC<cr>

" ----------------------------------------------------------------------------
"  Functions {{{1
" ----------------------------------------------------------------------------

function! s:close_preview() " {{{2
    if pumvisible() == 0 && bufname('%') != "[Command Line]"
        silent! pclose
    endif
endfunction

function! s:close_preview_on_move() " {{{2
    au CursorMovedI <buffer> call s:close_preview()
    au InsertLeave  <buffer> call s:close_preview()
endfunction

function! s:setup_haskell() " {{{2
    let g:haskellmode_completion_ghc = 0
    let g:necoghc_enable_detailed_browse = 1
    setlocal omnifunc=necoghc#omnifunc

    autocmd BufWritePost *.hs GhcModCheckAndLintAsync

    nmap <buffer> <F1> :GhcModType<CR>
    nmap <buffer> <silent> <F2> :GhcModTypeClear<CR>
    nmap <buffer> <silent> <leader>d <C-w><C-]><C-w>T
endfunction

function! s:setup_c() " {{{2
    call s:close_preview_on_move()
endfunction

function! s:setup_cpp() " {{{2
    call s:close_preview_on_move()
endfunction

function! s:setup_python() " {{{2
    let b:delimitMate_nesting_quotes = ['"','''', '`']
    call s:close_preview_on_move()
endfunction

function! s:setup_go() " {{{2
    setlocal noet
    nmap <buffer> <leader>d <Plug>(go-def-tab)
    call s:close_preview_on_move()
endfunction

function! s:setup_sh() " {{{2
    setlocal noet
endfunction

function! s:setup_pandoc() " {{{2
    setlocal nornu
endfunction

function! s:setup_rust() " {{{2
    nnoremap <buffer> <leader>d :YcmCompleter GoTo<CR>
endfunction

function! s:setup_yaml() " {{{2
    setlocal ts=2 sw=2 et
    autocmd BufWritePost package.yaml silent !hpack --silent
endfunction

function s:MkNonExDir(file, buf) " {{{2
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction

" ----------------------------------------------------------------------------
" Source the local vimrc if it exists

if glob("~/.dotfiles/local/vimrc")
    source ~/.dotfiles/local/vimrc
endif
