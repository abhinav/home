vim.cmd [[
" Continue comments on newlines with enter.
setlocal formatoptions+=r
]]

-- GoCoverage {{{1

local goc = require('nvim-goc')
vim.api.nvim_buf_create_user_command(0, "GoCoverage", function()
	-- Run in the file directory,
	-- and restore the previous directory after running.
	vim.cmd [[silent lcd %:p:h]]
	goc.Coverage()
	vim.cmd [[silent lcd -]]
end, {desc = "Show code coverage in this package"})

-- Highlight groups for :GoCoverage.
vim.api.nvim_set_hl(0, 'GocNormal', {link='Comment'})
vim.api.nvim_set_hl(0, 'GocCovered', {
	ctermfg = 'green',
	fg = '#A6E22E',
})
vim.api.nvim_set_hl(0, 'GocUncovered', {
	ctermfg = 'red',
	fg = '#F92672',
})

-- GoAlternate {{{1
vim.api.nvim_buf_create_user_command(0, "GoAlternate", function()
	-- foo.go => foo
	local other = vim.fn.expand("%:r")
	if other:sub(-5) == "_test" then
		other = other:sub(0, -6) .. ".go"
	else
		other = other .. "_test.go"
	end
	vim.cmd.edit(other)
end, {desc  = "Alternate between test and non-test files"})
