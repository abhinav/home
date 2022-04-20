" Provides support for numbered wiki files (referred to as memos here).

if exists('g:loaded_vimwiki_memo')
	finish
endif
let g:loaded_vimwiki_memo = 1

" wn starts a new memo.
nmap <silent> <leader>wn :call wikimemo#New()<CR>

" wf creates a new memo, using the motion to get its title.
nmap <silent> <leader>wf :set opfunc=wikimemo#New<CR>g@

" wf in visual mode creates a memo using the selected text as the title.
vmap <silent> <leader>wf :<C-U>call wikimemo#New(visualmode())<CR>
