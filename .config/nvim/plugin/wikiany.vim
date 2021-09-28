if exists('g:loaded_wikiany')
	finish
endif
let g:loaded_wikiany = 1

function! VimwikiLinkHandler(link)
	" Don't require file: prefix on attachments.
	if a:link =~ '\.\(pdf\|jpg\|jpeg\|png\|gif\)$'
		call vimwiki#base#open_link(':e ', 'file:' . a:link)
		return 1
	end

	" Support Markdown files to be placed anywhere in the vimwiki
	" directory, matching exclusively by name.
	let file = findfile(a:link . '.md', wikimemo#CurrentWikiDir() . '**')
	if file != ''
		exec 'edit ' . file
		return 1
	end

	return 0
endfunction


