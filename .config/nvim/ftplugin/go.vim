" Search for declarations by name in the current file or directory.
nmap <buffer> <leader>ss :GoDecls<CR>
nmap <buffer> <leader>sd :GoDeclsDir<CR>

call preview#AutoClose()
