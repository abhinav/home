if exists('b:markdown_extra_loaded')
	finish
endif
let b:markdown_extra_loaded = 1

setlocal nolist nonumber norelativenumber
setlocal shiftwidth=4 tabstop=4 expandtab
setlocal spell

" Wrap long lines and use j/k to move visually rather than on actual lines.
setlocal wrap linebreak
nnoremap <buffer> j gj
nnoremap <buffer> k gk

" Don't automatically wrap lines while typing.
setlocal formatoptions+=l

" For long lines that are part of lists, match indentation of the list item.
setlocal breakindent

" Let autowrite do its thing.
setlocal nohidden

" Treat blockquotes as comments so gq formats them nicely.
setlocal comments=n:>

nmap <buffer><silent> <C-P> :WikiFzfPages<CR>

" Use pandoc to reformat.
let &l:equalprg = 'pandoc -f markdown -t markdown --markdown-heading=atx --columns=' . &textwidth
