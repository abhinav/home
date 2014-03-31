set gfn=Menlo\ Regular:h12
colorscheme molokai

set go-=r
set go-=L
set go-=T

" Macvim specific
if has("gui_macvim")
    " Map Command-T
    macmenu &File.New\ Tab key=<nop>
    noremap <D-t> :<C-u>Unite -toggle -auto-resize file_rec/async:!<cr><c-u>
end
