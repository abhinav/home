if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

" ----------------------------------------------------------------------------
"  General Plugins {{{2
" ----------------------------------------------------------------------------
Plug 'cespare/vim-toml'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ervandew/supertab'
Plug 'honza/vim-snippets'
Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/molokai'
Plug 'justinmk/vim-sneak'
Plug 'machakann/vim-highlightedyank'
Plug 'mileszs/ack.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'rstacruz/sparkup', {'rtp': 'vim'}
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'Shougo/vimproc', {'do': 'make'}
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'Valloric/YouCompleteMe',
  \ {'do': './install.py --clang-completer --gocode-completer --racer-completer'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'visualrepeat'

" ----------------------------------------------------------------------------
"  Language-specific Plugins {{{2
" ----------------------------------------------------------------------------
Plug 'Arduino-syntax-file'
Plug 'davidhalter/jedi-vim', {'for': ['python', 'pyrex']}
Plug 'eagletmt/ghcmod-vim'
Plug 'eagletmt/neco-ghc'
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'hspec/hspec.vim'
Plug 'hynek/vim-python-pep8-indent'
Plug 'idris-hackers/idris-vim'
Plug 'jneen/ragel.vim'
Plug 'pbrisbin/html-template-syntax'
Plug 'rust-lang/rust.vim'
Plug 'solarnz/thrift.vim', {'for': 'thrift'}
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-after'
Plug 'vim-pandoc/vim-pandoc-syntax'

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

"  pandoc {{{2
let g:pandoc#after#modules#enabled = ["ultisnips"]
let g:pandoc#modules#disabled = ["folding"]
let g:pandoc#formatting#mode = "h"
let g:pandoc#formatting#extra_equalprg = "--reference-links --reference-location=section"
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
let g:syntastic_rust_checkers = ['rustc']

" netrw {{{2
let g:netrw_liststyle = 3

" airline {{{2
let g:airline_theme = "molokai"
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#displayed_head_limit = 10

"  Ack.vim {{{2
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

if executable('rg')
    let g:ackprg = 'rg --vimgrep'
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

" fzf {{{2
let g:fzf_layout = { 'down': '~15%' }

" YouCompleteMe {{{2
let g:ycm_global_ycm_extra_conf = '~/.dotfiles/default_ycm_extra_conf.py'
let g:ycm_extra_conf_globlist = ['~/dev/*','!~/*']
let g:ycm_goto_buffer_command = 'new-tab'
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']

if $RUST_SRC_PATH != ''
    let g:ycm_rust_src_path = $RUST_SRC_PATH
endif

" SuperTab {{{2
let g:SuperTabDefaultCompletionType = '<C-n>'
let g:SuperTabNoCompleteAfter = ['^', '\s', '[^\w]']

" UltiSnips {{{2
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

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
set tc=match            " Case sensitive for tag search
set sta                 " Smart tab
set bg=dark             " We have a dark background
set tw=78               " Wrap text after 78 characters
set vb                  " Use visual bell instead of beeping"
set sb                  " split below
set spr                 " split right
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

" Only bold out the current line
hi CursorLine term=bold cterm=bold

" Make line numbers in terminal more readable
hi LineNr ctermfg=245

" Use global python. Ensures nvim works with Python plugins inside a virtualenv.
let g:python_host_prog = '/usr/local/bin/python'

" Space = leader
let mapleader = "\<Space>"

" Highlight the current line, but only in the focused split.
augroup vimrc_cursor_hooks
    autocmd!
    autocmd WinEnter * setlocal cul
    autocmd BufEnter * setlocal cul
    autocmd WinLeave * setlocal nocul
augroup end
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
nnoremap <silent> <leader>evl :tabe ~/.dotfiles/local/vimrc<cr>
nnoremap <silent> <leader>svf :source $MYVIMRC<cr>

" fzf
nmap <silent> <C-P> :Files<CR>
nmap <silent> <leader>tt :Trees<CR>
nmap <silent> <leader>r :History<CR>
nmap <silent> <leader>bb :Buffers<CR>
nmap <silent> <leader>ww :Windows<CR>
nmap <silent> <leader>: :Commands<CR>

" Buffer shortcuts
nmap <silent> <leader>bd :bd<CR>
nmap <silent> <leader>bn :bn<CR>
nmap <silent> <leader>bp :bN<CR>

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

    augroup vimrc_haskell_hooks
        autocmd!
        autocmd BufWritePost *.hs GhcModCheckAndLintAsync
    augroup end

    nmap <buffer> <F1> :GhcModType<CR>
    nmap <buffer> <silent> <F2> :GhcModTypeClear<CR>
    nmap <buffer> <silent> <leader>d <C-w><C-]><C-w>T
endfunction

function! s:SetupC() " {{{2
    nmap <buffer> <leader>d :YcmCompleter GoTo<CR>
    call s:ClosePreviewOnMove()
endfunction

function! s:SetupCPP() " {{{2
    nmap <buffer> <leader>d :YcmCompleter GoTo<CR>
    call s:ClosePreviewOnMove()
endfunction

function! s:SetupPython() " {{{2
    let b:delimitMate_nesting_quotes = ['"','''', '`']
    call s:ClosePreviewOnMove()
endfunction

function! s:SetupGo() " {{{2
    setlocal noet
    nmap <buffer> <leader>d <Plug>(go-def-tab)
    call s:ClosePreviewOnMove()
endfunction

function! s:SetupSh() " {{{2
    setlocal noet
endfunction

function! s:SetupPandoc() " {{{2
    setlocal nolist
    setlocal nornu
endfunction

function! s:SetupRust() " {{{2
    nnoremap <buffer> <leader>d :YcmCompleter GoTo<CR>
endfunction

function! s:SetupYAML() " {{{2
    setlocal ts=2 sw=2 et
    augroup vimrc_yaml_hooks
        autocmd!
        autocmd BufWritePost package.yaml silent !hpack --silent
    augroup end
endfunction

" ----------------------------------------------------------------------------
" local vimrc {{{1
" ----------------------------------------------------------------------------

if glob("~/.dotfiles/local/vimrc")
    source ~/.dotfiles/local/vimrc
endif
