-- smart-splits calls this only when movement reaches Neovim's edge.
-- Hand off to the innermost multiplexer: tmux takes precedence when nested in Rex.
-- Outside either multiplexer, leave focus at the edge as ordinary wincmd does.
local function navigate(ctx)
	local command
	if vim.env.TMUX then
		local socket = vim.split(vim.env.TMUX, ',', { plain = true })[1]
		local directions = { left = 'L', down = 'D', up = 'U', right = 'R' }
		command = {
			'tmux', '-S', socket, 'select-pane', '-' .. directions[ctx.direction],
			'-t', vim.env.TMUX_PANE,
		}
	elseif vim.env.REX_SESSION and vim.env.REX_BLOCK then
		-- Rex puts its CLI on PATH inside its terminals. Directional focus uses
		-- the active pane in this session, so call it while this key is handled.
		command = { 'rex', 'focus', '-s', vim.env.REX_SESSION, ctx.direction, '--wrap' }
	else
		return
	end

	-- Complete each move before accepting the next so repeated keys stay ordered.
	local output = vim.fn.system(command)
	if vim.v.shell_error ~= 0 then
		vim.notify('Pane navigation failed: ' .. vim.trim(output), vim.log.levels.ERROR)
	end
end

return navigate
