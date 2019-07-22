" When trying to save a file in a directory that doesn't exist, automatically
" create it.

augroup Automkdir
	autocmd!
	autocmd BufWritePre * :call automkdir#Make(expand('<afile>'), +expand('<abuf>'))
augroup end
