if exists('b:loaded_vimwiki_overrides')
	finish
endif
let b:loaded_vimwiki_overrides = 1

" Remove annoying backspace mapping.
unmap <buffer> <BS>

" Remove vimwiki-only diary mappings.
unmap <buffer> <C-Down>
unmap <buffer> <C-Up>

" Replace vimwiki's new note command with our own.
unmap <buffer> <leader>wn

" Replace =-based header change with formatting with pandoc.
unmap <buffer> =
let &l:equalprg = 'pandoc -f markdown -t markdown --reference-links --markdown-heading=atx --columns=' . &textwidth

" Redefine VimwikiFollowLink so that <CR> on text that isn't a link doesn't
" try to convert it into a link. Instead, act like <CR> in normal mode, moving
" to the next line.
command! -buffer VimwikiFollowLink call wikilink#Follow()

" Treat blockquotes as comments so gq formats them nicely.
setlocal comments=n:>

" Don't suggest file-name based completions. When needed, these are provided
" by [[.
call ncm2#blacklist_for_buffer(['bufpath', 'rootpath', 'cwdpath'])
