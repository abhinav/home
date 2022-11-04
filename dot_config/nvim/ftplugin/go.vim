" Search for declarations by name in the current file or directory.
nmap <buffer> <leader>ss :GoDecls<CR>
nmap <buffer> <leader>sd :GoDeclsDir<CR>

call preview#AutoClose()

" Continue comments on new lines with CR.
setlocal formatoptions+=r
