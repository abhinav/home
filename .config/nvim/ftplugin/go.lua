vim.cmd [[
" Continue comments on newlines with enter.
setlocal formatoptions+=r
]]

-- GoCoverage {{{1

vim.api.nvim_buf_create_user_command(0, "GoCoverage", function()
	-- Run in the file directory,
	-- and restore the previous directory after running.
	vim.cmd [[silent lcd %:p:h]]
	require('go.coverage').run()
	vim.cmd [[silent lcd -]]
end, {desc = "Show code coverage in this package"})

-- More visible colors for code coverage signs.
vim.api.nvim_set_hl(0, 'goCoverageCovered', {
	ctermfg = 'green',
	fg = '#A6E22E',
})
vim.api.nvim_set_hl(0, 'goCoveragePartial', {
	ctermfg = 'yellow',
	fg = '#E6DB74',
})
vim.api.nvim_set_hl(0, 'goCoverageUncovered', {
	ctermfg = 'red',
	fg = '#F92672',
})
