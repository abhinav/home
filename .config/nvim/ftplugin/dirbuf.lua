local dirbuf = require('dirbuf')

-- C-V: open in a vertical split
-- C-H: open in a horizontal split
-- C-T: open in a tab

vim.keymap.set('n', '<C-V>', function()
	dirbuf.enter('vsplit')
end, {buffer = true, desc = "Open in a vertical split"})

vim.keymap.set('n', '<C-H>', function()
	dirbuf.enter('split')
end, {buffer = true, desc = "Open in a horizontal split"})

vim.keymap.set('n', '<C-T>', function()
	dirbuf.enter('tabnew')
end, {buffer = true, desc = "Open in a tab"})
