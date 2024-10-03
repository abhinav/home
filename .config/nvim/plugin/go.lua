-- Reformat and organize imports on save.

local goFormatAndImports = function(wait_ms)
	if vim.lsp.buf.format == nil then
		vim.lsp.buf.formatting_sync(nil, wait_ms)
	else
		vim.lsp.buf.format({
			timeout_ms = wait_ms,
		})
	end

	local params = vim.lsp.util.make_range_params()
	params.context = {only = {"source.organizeImports"}}
	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
	for _, res in pairs(result or {}) do
		for _, r in pairs(res.result or {}) do
			if r.edit then
				vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
			else
				vim.lsp.buf.execute_command(r.command)
			end
		end
	end
end


if not vim.env.VIM_GOPLS_DISABLED then
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*.go",
		callback = function(_)
			goFormatAndImports(3000)
		end,
	})
end
