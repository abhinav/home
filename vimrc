" ----------------------------------------------------------------------------
"  Vundle
" ----------------------------------------------------------------------------
syntax on
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" ----------------------------------------------------------------------------
"  Vundle Bundles
" ----------------------------------------------------------------------------

"  Vundle itself so :BundleClean does not remove it.
Bundle 'gmarik/vundle'

" ----------------------------------------------------------------------------
"  General Plugins
" ----------------------------------------------------------------------------
Bundle 'godlygeek/tabular'
Bundle 'wincent/Command-T'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'molokai'
Bundle 'Raimondi/delimitMate'
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'Shougo/vimproc'
Bundle 'SirVer/ultisnips'

" ----------------------------------------------------------------------------
"  Language-specific Plugins
" ----------------------------------------------------------------------------
Bundle 'eagletmt/ghcmod-vim'
Bundle 'groenewege/vim-less'
Bundle 'guns/vim-clojure-static'
Bundle 'jnwhiteh/vim-golang'
Bundle 'kchmck/vim-coffee-script'
Bundle 'pbrisbin/html-template-syntax'
Bundle 'Rip-Rip/clang_complete'
Bundle 'tpope/vim-haml'
Bundle 'ujihisa/neco-ghc'
Bundle 'Valloric/MatchTagAlways'
Bundle 'vim-pandoc/vim-pandoc'

filetype plugin indent on

" ----------------------------------------------------------------------------
"  Plugin Configuration
" ----------------------------------------------------------------------------

"  clang_complete
let g:clang_use_library = 1
let g:clang_periodic_quickfix = 0
let g:clang_close_preview = 1
let g:clang_snippets = 1
let g:clang_snippets_engine = 'ultisnips'

"  delimitMate
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 1
let g:delimitMate_autoclose = 1
let g:delimitMate_excluded_regions = "Comment,String"
let g:delimitMate_excluded_ft = "pandoc,txt"
au FileType python call s:setup_python()

"  pandoc
let g:pandoc_use_hard_wraps = 1
let g:pandoc_no_folding = 1

"  syntastic
let g:syntastic_enable_signs = 1
let g:syntastic_c_config_file = '.clang_complete'
let g:syntastic_cpp_config_file = '.clang_complete'

"  ghcmod-vim
au FileType haskell call s:setup_haskell()

" ----------------------------------------------------------------------------
"  General Configuration
" ----------------------------------------------------------------------------
set nocp                " Don't need compatibility with vi
set nobk                " Don't make backups
set nowb                " Don't make backups before overwrite
set bs=indent,eol,start " Allow backspace over everything
set hi=50               " Keep 50 lines of command line history
set ru                  " Show the cursor position all the time
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
colo molokai            " Use molokai

" File patterns to ignore in wildcard expansions.
set wig+=*/cabal-dev,*/dist,*.o,*.class

" Configuration available on OSX only:
if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin"
    set macmeta        " Use Option key as Meta
    set fuopt=maxvert  " Don't change width in OSX full screen mode
  endif
endif

" Use Ctrl-Space for omni completion.
if has("gui_running")
    inoremap <C-Space> <C-x><C-o>
else
    if has("unix")
        inoremap <Nul> <C-x><C-o>
    endif
endif

" ----------------------------------------------------------------------------
"  Functions
" ----------------------------------------------------------------------------

function! s:setup_haskell()
    nnoremap <buffer> <F1> :GhcModType<CR>
    nnoremap <buffer> <silent> <F2> :GhcModTypeClear<CR>
    setlocal omnifunc=necoghc#omnifunc
endfunction

function! s:close_preview()
    if pumvisible() == 0 && bufname('%') != "[Command Line]"
        silent! pclose
    endif
endfunction

function! s:setup_python()
    let b:delimitMate_nesting_quotes = ['"','''', '`']
    au CursorMovedI * call s:close_preview()
    au InsertLeave  * call s:close_preview()
endfunction

