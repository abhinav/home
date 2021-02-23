" Provides nvALT-like search-based creation of Vimwiki pages. Notes are
" searched based on content. If a note isn't selected, a new note is created
" with the provided title.
"
" Inspired by https://github.com/alok/notational-fzf-vim.
"
" Use <leader>wp or :NV to invoke it.
"
" In the search menu, the following keybindings are supported in addition to
" the usual fzf bindings.
"
"   ctrl-x  create a new note with the given title.
"   enter   if on a note, open that note, otherwise create a new note
"   ctrl-t  open the note in a new tab
"   ctrl-s  open the note in a horizontal split
"   ctrl-v  open the note in a vertical split

if exists('g:loaded_nvalt')
	finish
endif
let g:loaded_nvalt = 1


" If an argument was given to :NV, use that for the initial query, or use \S
" to only consider non-whitespace characters. Regardless, skip the YAML front
" matter separators and empty lines in the results when providing selctions.
"
" The -d/nth business makes it so that we're only searching the content, not
" the file name or line numbers.
command! -nargs=* NV
	\ call fzf#run(fzf#vim#with_preview({
		\ 'source': "rg -g '*.md' -g '!/archive' --files" .
			\ (<q-args> == '' ? '' : (' | rg ' . shellescape(<q-args>))),
		\ 'sink*': function('<SID>HandleSelection'),
		\ 'dir': wikimemo#CurrentWikiDir(),
		\ 'down': '40%',
		\ 'options': [
			\ '--ansi', '--no-multi', '--color=16', '--exact',
			\ '--expect=enter,ctrl-x,ctrl-t,ctrl-v,ctrl-s', '--print-query', '--no-sort',
			\ '--query', <q-args>,
		\ ],
	\ }))

nnoremap <silent> <leader>wp :NV<CR>

let s:action = {
	\ 'enter': 'edit',
	\ 'ctrl-t': 'tabedit',
	\ 'ctrl-v': 'vsplit',
	\ 'ctrl-s': 'split',
	\ }

function s:HandleSelection(lines)
	if len(a:lines) < 2
		return
	endif
	let query = a:lines[0]
	let key = a:lines[1]

	if key ==? 'ctrl-x'
		call wikimemo#NewWithTitle(query)
		return
	end

	if len(a:lines) < 3
		call wikimemo#NewWithTitle(query)
		return
	endif

	let dest = a:lines[2]
	let cmd = get(s:action, key, 'edit')

	exec cmd . ' ' . dest
endfunction
