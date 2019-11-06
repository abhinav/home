if exists('b:vimwiki_additions_loaded')
	finish
endif
let b:vimwiki_additions_loaded = 1

setlocal nolist nonumber norelativenumber
setlocal shiftwidth=4 tabstop=4 expandtab
setlocal spell foldlevel=1

let b:vimwiki_title_search_source =
	\ "rg -g '*.md' --no-heading -N -m 1 -x"
	\ . " -e " . shellescape('title:\s*["'']?(?P<t1>.*?)["'']?')
	\ . " -e " . shellescape('#\s+(?P<t2>.*)')
	\ . " -r " . shellescape('$t1$t2')

" FZF options to search wikis by title.
let b:vimwiki_title_search = {
	\ 'dir': vimwiki#vars#get_wikilocal('path'),
	\ 'down': '40%',
	\ 'options': [
		\ '--ansi', '--no-multi', '--color=16',
		\ '-d:', '--preview', '(bat --color=always {1} || cat {1}) 2>/dev/null | head -n100',
	\],
\}

" Puts the name of the current file into the system register.
nmap <buffer><silent> <leader>fn :call setreg("+", expand('%:t:r'))<CR>

" <leader>wy to copy rich text from Markdown.
nmap <buffer><silent> <leader>wy :set opfunc=wikicopy#Copy<CR>g@
vmap <buffer><silent> <leader>wy :<C-U>call wikicopy#Copy(visualmode(), 1)<CR>

" <Leader><Enter> to open a link in a tab.
nmap <buffer> <leader><cr> <Plug>VimwikiTabnewLink

" Use [[ to search for files by title and generate a complete link to them,
" including the title.
imap <buffer><silent><expr> [[ fzf#vim#complete(
	\ extend(copy(b:vimwiki_title_search), {
		\ 'source': b:vimwiki_title_search_source,
		\ 'reducer': function('<sid>buildWikiOpenLink', [vimwiki#vars#get_wikilocal('path')])
	\ }),
\ )

" Use ]] to search for files by title and generate only the ](foo) part of the
" link.
imap <buffer><silent><expr> ]] fzf#vim#complete(
	\ extend(copy(b:vimwiki_title_search), {
		\ 'prefix': '\[\zs.*$',
		\ 'source': b:vimwiki_title_search_source,
		\ 'reducer': function('<sid>buildWikiCloseLink', [vimwiki#vars#get_wikilocal('path')])
	\ }),
\ )


" Override Ctrl-P to use titles rather than file names.
nmap <buffer><silent> <C-P> :call fzf#vim#grep(
	\ b:vimwiki_title_search_source, 0,
	\ copy(b:vimwiki_title_search)
\ )<CR>

" Builds a Markdown-style link.
function! s:buildWikiOpenLink(wikidir, lines)
	let toks = split(a:lines[0], ':')
	let dest = toks[0]
	let title = trim(join(toks[1:], ':'))

	return printf('[%s](%s)', title, s:wikiRelPath(a:wikidir, dest))
endfunction

function! s:buildWikiCloseLink(wikidir, lines)
	let toks = split(a:lines[0], ':')
	let dest = toks[0]
	let prefix = matchstr(getline('.')[0:col('.')-2], '\[\zs.*$')

	return printf('%s](%s)', prefix, s:wikiRelPath(a:wikidir, dest))
endfunction

function! s:wikiRelPath(wikidir, dest)
	" foo/bar.md => ~/.notes/foo/bar.md => ~/.notes/foo/bar
	let wikifile = fnamemodify(vimwiki#path#join_path(a:wikidir, a:dest), ':r')

	" ~/.notes/foo/bar => ../foo/bar.
	let current_file = vimwiki#path#current_wiki_file()
	return vimwiki#path#relpath(fnamemodify(current_file, ':h'), wikifile)
endfunction
