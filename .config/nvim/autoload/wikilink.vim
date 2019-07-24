" Hook to follow wiki links in Vimwiki.
function wikilink#Follow()
	" Clear search highlights on enter like other file types'
	" configuration.
	"
	" feedkeys is needed here because as per :help nohlsearch, it doesn't
	" work inside user functions.
	"
	" We feed an echo as well to clear the command line so that the
	" :nohlsearch doesn't linger afterwards.
	call feedkeys(":nohlsearch\<CR>:echo\<CR>")

	call vimwiki#base#follow_link('nosplit', 0, 1, 'j')
endfunction
