" Starts a new numbered wiki page in the current wiki's root, or the default
" one if a wiki is not open. (Temporary wikis don't count.)
"
" May be used as a motion or a visual selection over the title.
function wikimemo#New(...)
	let wiki_nr = vimwiki#vars#get_bufferlocal('wiki_nr')
	let in_wiki = wiki_nr != -1
	let wiki_dir = wikimemo#CurrentWikiDir()

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
				\ . printf("[[%s]]", title)
				\ . line[endcol + 1:]
			call setline(startline, new_line)
		endif
	else
		let title = input("Title: ")
	endif

	call s:newWikiNote(wiki_dir, title)
endfunction

" Given a valid wiki directory and a note name relative to the root of the
" directory, creates a new note with the given title if it doesn't already
" exist.
function s:newWikiNote(wiki_dir, title)
	let name = a:title
	if name =~ '\d\{4\}_\d\{2\}_\d\{2\}'
		let note_name = printf("journals/%s", name)
	else
		" logseq replaces '/' in the name with '.'.
		let name = substitute(name, '/', '.', 'g')
		let note_name = printf("pages/%s", name)
	end

	let wiki_index = a:wiki_dir . '/index.md'
	let link = vimwiki#base#resolve_link(note_name, wiki_index)
	let already_exists = !empty(glob(link.filename))

	call vimwiki#base#open_link(':e ', note_name . '.md', wiki_index)

	if already_exists
		return
	end

	" If this is a new file and the name of the file does not
	" match the title provided by the user, or it contains a '.',
	" add a 'title::' propery.
	if name != a:title || a:title =~ '\.'
		call append(line('1'),
			\ [ printf('title:: %s', a:title),
			\ ])
	end

	exec 'normal G'
	startinsert!
endfunction

" Creates and opens a new wiki page with the given title.
function wikimemo#NewWithTitle(title)
	call s:newWikiNote(wikimemo#CurrentWikiDir(), a:title)
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
