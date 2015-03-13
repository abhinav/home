" ----------------------------------------------------------------------------
"  Vundle Setup {{{1
" ----------------------------------------------------------------------------
syntax on
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" ----------------------------------------------------------------------------
"  Vundle Bundles {{{1
" ----------------------------------------------------------------------------

"  Vundle itself so :BundleClean does not remove it.
Plugin 'gmarik/Vundle.vim'

" ----------------------------------------------------------------------------
"  General Plugins {{{2
" ----------------------------------------------------------------------------
Plugin 'bling/vim-airline'
Plugin 'godlygeek/tabular'
Plugin 'honza/vim-snippets'
Plugin 'molokai'
Plugin 'Raimondi/delimitMate'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'Shougo/vimproc'
Plugin 'SirVer/ultisnips'
Plugin 'tpope/vim-fugitive'
Plugin 'wincent/command-t'

" ----------------------------------------------------------------------------
"  Language-specific Plugins {{{2
" ----------------------------------------------------------------------------
Plugin 'davidhalter/jedi-vim'
Plugin 'eagletmt/ghcmod-vim'
Plugin 'fatih/vim-go'
Plugin 'idris-hackers/idris-vim'
Plugin 'pbrisbin/html-template-syntax'
Plugin 'ujihisa/neco-ghc'
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-after'
Plugin 'vim-pandoc/vim-pandoc-syntax'
Plugin 'wting/rust.vim'

call vundle#end()
filetype plugin indent on

" ----------------------------------------------------------------------------
"  File type hooks {{{1
" ----------------------------------------------------------------------------

au FileType python call s:setup_python()
au FileType haskell,chaskell call s:setup_haskell()
au FileType go call s:setup_go()
au FileType sh call s:setup_sh()
au FileType text set nornu
au FileType pandoc call s:setup_pandoc()

augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup end

" ----------------------------------------------------------------------------
"  Plugin Configuration {{{1
" ----------------------------------------------------------------------------

"  clang_complete {{{2
let g:clang_use_library = 1
let g:clang_periodic_quickfix = 0
let g:clang_close_preview = 1
let g:clang_snippets = 1
let g:clang_snippets_engine = 'ultisnips'

"  delimitMate {{{2
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 1
let g:delimitMate_autoclose = 1
let g:delimitMate_excluded_regions = "Comment,String"
let g:delimitMate_excluded_ft = "pandoc,txt"

"  pandoc {{{2
let g:pandoc#after#modules#enabled = ["ultisnips"]
let g:pandoc#modules#disabled = ["folding"]
let g:pandoc#formatting#mode = "h"
let g:pandoc#syntax#conceal#use = 0

"  syntastic {{{2
let g:syntastic_enable_signs = 1
let g:syntastic_c_config_file = '.clang_complete'
let g:syntastic_cpp_config_file = '.clang_complete'

" netrw {{{2
let g:netrw_liststyle = 3

" airline {{{2
let g:airline_theme = "dark"
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#displayed_head_limit = 10

" Command-T {{{2
if executable("watchman")
    let g:CommandTFileScanner = 'watchman'
endif
let g:CommandTHighlightColor = 'Pmenu'

" Jedi Vim {{{2
let g:jedi#show_call_signatures=0

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
set cul                 " Highlight the current line
colo molokai            " Use molokai

" File patterns to ignore in wildcard expansions.
set wig+=*/cabal-dev,*/dist,*.o,*.class,*.pyc

" Support codex tags.
set tags+=codex.tags

" Only bold out the current line
hi clear CursorLine
hi CursorLine term=bold cterm=bold

" ----------------------------------------------------------------------------
"  Key Remaps {{{1
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

" Disable ex mode from Q
nnoremap Q <Nop>

" ----------------------------------------------------------------------------
"  Functions {{{1
" ----------------------------------------------------------------------------

function! s:close_preview() " {{{2
    if pumvisible() == 0 && bufname('%') != "[Command Line]"
        silent! pclose
    endif
endfunction

function! s:close_preview_on_move() " {{{2
    au CursorMovedI * call s:close_preview()
    au InsertLeave  * call s:close_preview()
endfunction

function! s:setup_haskell() " {{{2
    nnoremap <buffer> <F1> :GhcModType<CR>
    nnoremap <buffer> <silent> <F2> :GhcModTypeClear<CR>
    setlocal omnifunc=necoghc#omnifunc
endfunction

function! s:setup_python() " {{{2
    let b:delimitMate_nesting_quotes = ['"','''', '`']
    call s:close_preview_on_move()
endfunction

function! s:setup_go() " {{{2
    set noet
    call s:close_preview_on_move()
endfunction

function! s:setup_sh() " {{{2
    set noet
endfunction

function! s:setup_pandoc() " {{{2
    set nornu
endfunction

function s:MkNonExDir(file, buf) " {{{2
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
