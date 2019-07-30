if exists('b:vimwiki_additions_loaded')
	finish
endif
let b:vimwiki_additions_loaded = 1

setlocal nolist nonumber norelativenumber
setlocal shiftwidth=4 tabstop=4 expandtab
setlocal spell foldlevel=1

let b:vimwiki_title_search_source = "rg -g '*.md' --no-heading -N -m 1 -x -e '\\s*title:\\s*(.*)' -e '#\\s+(.*)' -r '$1'"

" FZF options to search wikis by title.
let b:vimwiki_title_search = {
	\ 'dir': vimwiki#vars#get_wikilocal('path'),
	\ 'down': '40%',
	\ 'options': [
		\ '--ansi', '--no-multi', '--color=16',
		\ '-d:', '--preview', '(bat --color=always {1} || cat {1}) 2>/dev/null',
	\],
\}

" Puts the name of the current file into the system register.
nmap <buffer><silent> <leader>fn :call setreg("+", expand('%:t:r'))<CR>

" [[-based search for entries.
imap <buffer><silent><expr> [[ fzf#vim#complete(
	\ extend(copy(b:vimwiki_title_search), {
		\ 'source': b:vimwiki_title_search_source,
		\ 'reducer': function('<sid>buildWikiLink', [vimwiki#vars#get_wikilocal('path')])
	\ }),
\ )

" Override Ctrl-P to use titles rather than file names.
nmap <buffer><silent> <C-P> :call fzf#vim#grep(
	\ b:vimwiki_title_search_source, 0,
	\ copy(b:vimwiki_title_search)
\ )<CR>

" Builds a Markdown-style link.
function! s:buildWikiLink(wikidir, lines)
	let toks = split(a:lines[0], ':')
	let title = trim(join(toks[1:], ':'))

	" foo/bar.md => ~/.notes/foo/bar.md => ~/.notes/foo/bar
	let wikifile = fnamemodify(vimwiki#path#join_path(a:wikidir, toks[0]), ':r')
	let current_file = vimwiki#path#current_wiki_file()

	" ~/.notes/foo/bar => ../foo/bar.
	let rel_path = vimwiki#path#relpath(fnamemodify(current_file, ':h'), wikifile)
	return printf('[%s](%s)', title, rel_path)
endfunction
