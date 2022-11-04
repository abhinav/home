local uri_re = vim.regex([[\v^\w+\:\/]])

function _G.wikiResolver(fname, origin)
	if fname == "" then
		return origin
	end

	-- Allow placing Markdown files anywhere in the system.
	local curWiki = vim.fn['wiki#get_root']()
	local fname = fname:gsub(".md$", "")
	local file = vim.fn.findfile(fname .. '.md', curWiki .. '**')
	if file then
		return file
	end
	return origin
end

vim.cmd([[
function! WikiResolver(fname, origin)
	return v:lua.wikiResolver(a:fname, a:origin)
endfunction
let g:wiki_resolver = 'WikiResolver'
]])
