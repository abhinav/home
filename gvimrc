set gfn=Menlo\ Regular:h12
colorscheme molokai

set go-=r
set go-=L
set go-=T

" Macvim specific
if has("gui_macvim")
    " Map Command-T
    macmenu &File.New\ Tab key=<nop>
    map <D-t> :CommandT<CR>
end
