" Remove annoying backspace mapping.
unmap <buffer> <BS>

" Remove vimwiki-only diary mappings.
unmap <buffer> <C-Down>
unmap <buffer> <C-Up>

" Redefine VimwikiFollowLink so that <CR> on text that isn't a link doesn't
" try to convert it into a link. Instead, act like <CR> in normal mode, moving
" to the next line.
command! -buffer VimwikiFollowLink call vimwiki#base#follow_link('nosplit', 0, 1, 'j')
