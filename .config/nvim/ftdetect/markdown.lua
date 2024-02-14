vim.api.nvim_create_autocmd(
	{"BufNewFile", "BufFilePre", "BufRead"},
	{
		pattern = {"*.md"},
		callback = function()
			-- For some reason, the syntax is not set by default.
			vim.bo.syntax = "markdown"
		end,
	}
)
