if exists('b:vimwiki_additions_loaded')
	finish
endif
let b:vimwiki_additions_loaded = 1

setlocal nolist nonumber norelativenumber
setlocal shiftwidth=4 tabstop=4 expandtab
setlocal spell foldlevel=1

" Wrap long lines and use j/k to move visually rather than on actual lines.
setlocal wrap linebreak
nnoremap <buffer> j gj
nnoremap <buffer> k gk

" Don't automatically wrap lines while typing.
setlocal formatoptions-=t

" For long lines that are part of lists, match indentation of the list item.
setlocal breakindent

" Let autowrite do its thing.
setlocal nohidden

let b:vimwiki_title_search_source =
	\ "rg -g '*.md' -g '!/archive' --files"

" FZF options to search wikis by title.
let b:vimwiki_title_search = {
	\ 'dir': vimwiki#vars#get_wikilocal('path'),
	\ 'down': '40%',
	\ 'options': [
		\ '--ansi', '--no-multi', '--color=16',
		\ '--preview', '(bat --color=always {} || cat {}) 2>/dev/null | head -n100',
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
		\ 'reducer': function('<sid>buildWikiOpenLink')
	\ }),
\ )

" TODO: Support '|' and '#'

" Override Ctrl-P to use titles rather than file names.
nmap <buffer><silent> <C-P> :NV<CR>

" Builds a Markdown-style link.
function! s:buildWikiOpenLink(lines)
	let dest = fnamemodify(a:lines[0],  ':r')
	return printf('[[%s]]', dest)
endfunction
