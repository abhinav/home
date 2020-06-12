" Starts a new numbered wiki page in the current wiki's root, or the default
" one if a wiki is not open. (Temporary wikis don't count.)
"
" May be used as a motion or a visual selection over the title.
function wikimemo#New(...)
	let wiki_nr = vimwiki#vars#get_bufferlocal('wiki_nr')
	let in_wiki = wiki_nr != -1
	let wiki_dir = wikimemo#CurrentWikiDir()
	let note_id = s:generateMemoID()

	" If invoked as an operator (via a motion), the ranged-over text will
	" be the title.
	let title = ''
	if a:0
		if a:1 != 'char' && a:1 != 'v'
			echoerr 'Only single-line (charwise) ranges can'.
				\ ' be used to create titles.'
			return
		endif

		let [startline, startcol] = getpos(a:1 == 'v' ? "'<" : "'[")[1:2]
		let [endline, endcol] = getpos(a:1 == 'v' ? "'>" : "']")[1:2]
		if startline != endline
			echoerr 'Only single-line (charwise) ranges can'.
				\ ' be used to create titles.'
			return
		endif

		let line = getline(startline)
		let startcol = startcol - 1
		let endcol = endcol - 1
		let title = trim(line[startcol:endcol])

		" If we're in a wiki file, replace the affected text with a
		" link.
		if in_wiki
			let new_line
				\ = (startcol ? line[:startcol-1] : '')
				\ . printf("[[%s %s]]", note_id, title)
				\ . line[endcol + 1:]
			call setline(startline, new_line)
		endif
	else
		let title = input("Title: ")
	endif

	call s:newWikiNote(wiki_dir, note_id, title)
endfunction

" Given a valid wiki directory and a note name relative to the root of the
" directory, creates a new note with the given title if it doesn't already
" exist.
function s:newWikiNote(wiki_dir, note_id, title)
	" TODO: validate title

	let note_name = printf("%s %s", a:note_id, a:title)
	let wiki_index = a:wiki_dir . '/index.md'

	call vimwiki#base#open_link(':e ', note_name, wiki_index)
endfunction

function s:generateMemoID()
	return strftime('%Y%m%d%H%M')
endfunction

" Creates and opens a new wiki page with the given title.
function wikimemo#NewWithTitle(title)
	call s:newWikiNote(wikimemo#CurrentWikiDir(), s:generateMemoID(), a:title)
endfunction

" Returns the path to the current wiki directory, or the default directory if
" we're not inside one, or if we're inside a temporary wiki.
function wikimemo#CurrentWikiDir()
	let wiki_nr = vimwiki#vars#get_bufferlocal('wiki_nr')
	if wiki_nr == -1 || vimwiki#vars#get_wikilocal('is_temporary_wiki', wiki_nr)
		let wiki_nr = 0
	endif
	return vimwiki#vars#get_wikilocal('path', wiki_nr)
endfunction
