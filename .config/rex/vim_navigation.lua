-- Route Ctrl+H/J/K/L into Vim or tmux; other programs navigate Rex panes.
-- Vim's smart-splits edge callback and tmux's own bindings handle navigation
-- within those programs before handing off to their surrounding panes.
for _, binding in ipairs({ { "h", "left" }, { "j", "down" }, { "k", "up" }, { "l", "right" } }) do
	local key = "ctrl+" .. binding[1]
	local direction = binding[2]
	local name = "navigate_" .. direction
	rex.action {
		name = name,
		title = "Navigate " .. direction,
		repeats = true,
		run = function()
			local process = rex.block.call("com.superlogical.terminal", "process", {})
			local command = process and process.foreground and process.foreground.name or ""
			-- Match the Vim variants and editor hosts recognized by ~/.tmux.conf.
			local vim_command = command:gsub("^g", ""):gsub("diff$", "")
			if command == "tmux" or command == "tig" or command == "lazygit"
				or vim_command == "view" or vim_command:match("^n?vim?$") then
				rex.client.queue("pane.send_key", { key = key })
			else
				local result, err = rex.session.focus_direction { direction = direction, wrap = true }
				if not result then
					error(err)
				end
			end
		end,
	}
	rex.bind(key, name)
end
