" Provides the ability to automatically close Preview windows when the cursor
" moves.
"
" Must be opted-into on a per-filetype basis by calling preview#AutoClose()

function preview#AutoClose()
	autocmd CursorMovedI,InsertLeave <buffer> call s:ClosePreview()
endfunction

function! s:ClosePreview()
	if pumvisible() == 0 && bufname('%') != "[Command Line]"
		silent! pclose
	endif
endfunction
