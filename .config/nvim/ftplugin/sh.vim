" Use shfmt to format with gq.
if executable('shfmt')
	let &l:formatprg='shfmt -s'
endif
