-- Return a bind(key, action, args) helper for use while loading init.lua.
-- Keys use Rex's binding syntax, including > between keys in a sequence.
-- Targets may be client actions or config actions registered with rex.action.
local binding_count = 0

-- Check the foreground process on each invocation: tmux receives the original
-- sequence; other processes, or unavailable process information, use the target.
-- This sees the terminal host's processes, so tmux inside SSH is not detected.
local function bind(key, action, args)
	binding_count = binding_count + 1
	local name = "prefix_binding_" .. binding_count
	local keys = {}
	for part in key:gmatch("[^>]+") do
		keys[#keys + 1] = part
	end

	-- Each binding gets its own action so its callback retains its keys and target.
	rex.action {
		name = name,
		title = key .. ": " .. action,
		-- The wrapper does not inherit the target's repeat flag; opt in here for
		-- targets that should run again while the final key is held.
		repeats = action == "pane.resize" or action == "cycle_pane" or action == "pane.send_key"
			or action == "client.tab.next" or action == "client.tab.previous",
		run = function()
			local process = rex.block.call("com.superlogical.terminal", "process", {})
			if process and process.foreground and process.foreground.name == "tmux" then
				-- The client consumed the prefix, so forward it along with the last key.
				for _, original_key in ipairs(keys) do
					rex.client.queue("pane.send_key", { key = original_key })
				end
			elseif action:find(".", 1, true) then
				-- Client actions run in the app after this callback returns, in queue order.
				rex.client.queue(action, args)
			else
				-- Names without dots identify config actions, which run on the server.
				local _, err = rex.invoke(action, args)
				if err then
					error(err)
				end
			end
		end,
	}
	rex.bind(key, name)
end

return bind
