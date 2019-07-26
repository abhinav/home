" Starts a new numbered wiki page in the current wiki's root, or the default
" one if a wiki is not open. (Temporary wikis don't count.)
function wikimemo#New(...)
	let wiki_nr = vimwiki#vars#get_bufferlocal('wiki_nr')
	let wiki_dir = ''
	let in_wiki = wiki_nr != -1
	if in_wiki
 		let wiki_dir = vimwiki#vars#get_wikilocal('path', wiki_nr)
	endif

	let memo_name = strftime('%y%m%d%H%M')

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
			" Relative path to the new file from the current file.
			let rel_path = vimwiki#path#relpath(
				\ fnamemodify(vimwiki#path#current_wiki_file(), ':h'),
				\ vimwiki#path#join_path(wiki_dir, memo_name),
				\ )

			let new_line
				\ = (startcol ? line[:startcol-1] : '')
				\ . printf("[%s](%s)", title, rel_path)
				\ . line[endcol + 1:]
			call setline(startline, new_line)
		endif
	endif


	" Use the default wiki if we're not inside a wiki or using a temporary
	" one.
	if wiki_dir == '' || vimwiki#vars#get_wikilocal('is_temporary_wiki', wiki_nr)
		let wiki_dir = vimwiki#vars#get_wikilocal('path', 0)
	endif
	let wiki_index = wiki_dir . '/index.md'
	let link = vimwiki#base#resolve_link(memo_name, wiki_index)
	let already_exists = !empty(glob(link.filename))

	call vimwiki#base#open_link(':e ', memo_name, wiki_index)

	if already_exists
		return
	endif

	" This is a new file. Add the template and reposition the cursor.

	call append(line('1'),
		\ [
		\ '---',
		\ printf('title: %s', title),
		\ printf('date: %s', strftime('%Y-%m-%d %H:%M')),
		\ '---',
		\ '',
		\ ])

	" If no title was given, move cursor in position to write the title.
	" Otherwise, move to the body of the note.
	if title == ''
		exec 2
	else
		exec 'normal G'
	endif

	startinsert!
endfunction
