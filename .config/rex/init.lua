local binding_count = 0

-- Let a foreground tmux client handle the full sequence; otherwise run Rex.
local function bind(key, action, args)
	binding_count = binding_count + 1
	local name = "prefix_binding_" .. binding_count
	local keys = {}
	for part in key:gmatch("[^>]+") do
		keys[#keys + 1] = part
	end

	rex.action {
		name = name,
		title = key .. ": " .. action,
		repeats = action == "pane.resize" or action == "pane.send_key"
			or action == "client.tab.next" or action == "client.tab.previous",
		run = function()
			local process = rex.block.call("com.superlogical.terminal", "process", {})
			if process and process.foreground and process.foreground.name == "tmux" then
				-- The client consumed the prefix, so forward it along with the last key.
				for _, original_key in ipairs(keys) do
					rex.client.queue("pane.send_key", { key = original_key })
				end
			else
				rex.client.queue(action, args)
			end
		end,
	}
	rex.bind(key, name)
end

-- Use Ctrl+B as the prefix; press it twice to send Ctrl+B to the terminal.
bind("ctrl+b>ctrl+b", "pane.send_key", { key = "ctrl+b" })
bind("ctrl+b>shift+r", "client.config.reload")

-- Keep Ctrl held after B to split right or down.
bind("ctrl+b>ctrl+\\", "pane.split", { direction = "right" })
bind("ctrl+b>ctrl+-", "pane.split", { direction = "down" })
bind("ctrl+b>ctrl+shift+-", "pane.split", { direction = "down" })

-- Move split dividers in steps of 10 percent.
bind("ctrl+b>ctrl+h", "pane.resize", { direction = "left", amount = 10 })
bind("ctrl+b>ctrl+j", "pane.resize", { direction = "down", amount = 10 })
bind("ctrl+b>ctrl+k", "pane.resize", { direction = "up", amount = 10 })
bind("ctrl+b>ctrl+l", "pane.resize", { direction = "right", amount = 10 })

-- Break a pane into a new tab, join it to another tab, or choose a session.
bind("ctrl+b>shift+,", "pane.move_to_new_tab")
bind("ctrl+b>shift+.", "pane.move_to_tab")
bind("ctrl+b>shift+6", "session.switch")

-- Create, select, and rename tabs, or zoom and close the focused pane.
bind("ctrl+b>c", "client.tab.new")
bind("ctrl+b>n", "client.tab.next")
bind("ctrl+b>p", "client.tab.previous")
bind("ctrl+b>,", "client.tab.rename")
bind("ctrl+b>z", "pane.zoom")
bind("ctrl+b>x", "pane.close")
for index = 1, 9 do
	bind("ctrl+b>" .. index, "client.tab.goto", { index = index })
end
