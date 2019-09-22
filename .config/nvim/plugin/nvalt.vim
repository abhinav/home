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
		\ 'source': "rg -g '*.md' --no-heading --line-number -e " .
			\ (<q-args> == '' ? '"\S"' : shellescape(<q-args>)) .
			\ "| rg -v -x -e '([^:]+:){2}\s*?(---)?\s*?'",
		\ 'sink*': function('<SID>HandleSelection'),
		\ 'dir': wikimemo#CurrentWikiDir(),
		\ 'down': '40%',
		\ 'options': [
			\ '--ansi', '--no-multi', '--color=16', '--exact',
			\ '--expect=enter,ctrl-x', '--print-query',
			\ '-d:', '--nth=1,3..', '--no-sort',
			\ '--query', <q-args>,
		\ ],
	\ }))

nnoremap <silent> <leader>wp :NV<CR>

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

	exec 'edit ' . split(a:lines[2], ':')[0]
endfunction
