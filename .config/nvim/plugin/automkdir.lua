-- When trying to save a file in a directory that does not exist,
-- automatically create the parent directory.

local uri_re = vim.regex([[\v^\w+\:\/]])
local uv = vim.loop

local automkdir = function(args)
	local file = args.file
	local buf = args.buf

	-- skip non-standard buffers and URIs.
	local btype = vim.api.nvim_buf_get_option(buf, 'buftype')
	if btype ~= '' or uri_re:match_str(file) then
		return
	end

	local dir = vim.fn.fnamemodify(file, ':h')
	if uv.fs_stat(dir) == nil then
		vim.fn.mkdir(dir, 'p')
	end
end

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = automkdir,
})
