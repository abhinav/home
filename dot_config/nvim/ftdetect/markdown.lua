vim.api.nvim_create_autocmd(
	{"BufNewFile", "BufFilePre", "BufRead"},
	{
		pattern = {"*.md"},
		callback = function()
			vim.bo.filetype = "markdown.pandoc"
		end,
	}
)
