" Copies the contents of the provided text as rich text.
func wikicopy#Copy(kind, ...)
	if a:0
		let start = "'<"
		let end = "'>"
	else
		let start = "'["
		let end = "']"
	endif
	exec 'silent ' start . ',' . end . 'w !pandoc --standalone -f markdown -t rtf | pbcopy'
	echo "Rich text copied"
endfunction
