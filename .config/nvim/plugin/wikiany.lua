local uri_re = vim.regex([[\v^\w+\:\/]])
local attachment_re = vim.regex([[\.(pdf|jpe?g|png|gif)$]])

function _G.vimwikiLinkHandler(link)
	-- Don't try to resolve to a Markdown file
	-- if this is a URI with a scheme:/.
	if uri_re:match_str(link) then
		return 0
	end

	-- Open attachments with the standard vimwiki opener
	-- without requiring a 'file:' prefix.
	if attachment_re:match_str(link) then
		vim.fn['vimwiki#base#open_link'](':e', 'file:' .. link)
	end

	-- Allow placing Markdown files anywhere in the system.
	local curWiki = vim.fn['wikimemo#CurrentWikiDir']()
	local file = vim.fn.findfile(link .. '.md', curWiki .. '**')
	if file then
		vim.cmd('edit ' .. file)
		return 1
	end

	return 0
end

vim.cmd([[
function! VimwikiLinkHandler(link)
	return v:lua.vimwikiLinkHandler(a:link)
endfunction
]])
