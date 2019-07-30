if exists('b:loaded_vimwiki_overrides')
	finish
endif
let b:loaded_vimwiki_overrides = 1

" Remove annoying backspace mapping.
unmap <buffer> <BS>

" Remove vimwiki-only diary mappings.
unmap <buffer> <C-Down>
unmap <buffer> <C-Up>

" Redefine VimwikiFollowLink so that <CR> on text that isn't a link doesn't
" try to convert it into a link. Instead, act like <CR> in normal mode, moving
" to the next line.
command! -buffer VimwikiFollowLink call wikilink#Follow()

EnableWhitespace