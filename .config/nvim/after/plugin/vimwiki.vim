" Remove unused diary shortcuts.
let s:map_prefix = vimwiki#vars#get_global('map_prefix')
exec 'unmap ' . s:map_prefix . 'i'
exec 'unmap ' . s:map_prefix . '<leader>i'
exec 'unmap ' . s:map_prefix . '<leader>w'
exec 'unmap ' . s:map_prefix . '<leader>t'
exec 'unmap ' . s:map_prefix . '<leader>y'
exec 'unmap ' . s:map_prefix . '<leader>m'

" Prefer Markdown-style links.
let g:vimwiki_global_vars.WikiLinkTemplate2 = '[__LinkDescription__](__LinkUrl__)'
