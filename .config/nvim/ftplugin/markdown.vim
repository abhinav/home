if exists("b:did_markdown_custom")
	finish
endif
let b:did_markdown_custom = 1

setlocal nolist nonumber norelativenumber
setlocal spell

" Wrap long lines and use j/k to move visually rather than on actual lines.
setlocal wrap linebreak
nnoremap <buffer> j gj
nnoremap <buffer> k gk

" For long lines that are part of lists, match indentation of the list item.
setlocal breakindent

" Don't automatically wrap lines while typing.
setlocal formatoptions+=l

" Treat blockquotes as comments so gq formats them nicely.
setlocal comments=n:>

" Use pandoc to reformat.
let &l:equalprg = 'pandoc -f markdown -t markdown --markdown-heading=atx --columns=' . &textwidth
