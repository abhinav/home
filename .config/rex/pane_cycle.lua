-- Requiring this module registers cycle_pane for bindings in init.lua.
-- The action swaps ctx.block_id with another pane in the same window and layer.
-- Use step = 1 for the next pane or -1 for the previous pane, with wraparound.
-- A lone pane or a block absent from the visible layout leaves the layout alone.
-- Failures to read the layout or swap panes are reported as action errors.

local find_cycle_target, collect_panes

rex.action {
	name = "cycle_pane",
	title = "Cycle Pane",
	args = { step = "integer" },
	repeats = true,
	run = function(ctx, args)
		local view, err = rex.session.view {}
		if not view then
			error(err)
		end

		local other_block_id = find_cycle_target(view, ctx.block_id, args.step)
		if not other_block_id then
			return
		end

		-- Rex preserves split geometry when swapping positions.
		-- Focus follows the block to its new position.
		local result, swap_err = rex.session.swap_blocks {
			block_id = ctx.block_id,
			other_block_id = other_block_id,
		}
		if not result then
			error(swap_err)
		end
	end,
}

-- Return the neighboring pane ID in the block's own layer, or nil if none exists.
find_cycle_target = function(view, block_id, step)
	for _, window in ipairs(view.windows or {}) do
		for _, layer in ipairs(window.layers or {}) do
			local panes = {}
			if layer.layout then
				collect_panes(layer.layout, panes)
			end
			for index, pane_id in ipairs(panes) do
				if pane_id == block_id then
					if #panes < 2 then
						return
					end
					-- Convert to a zero-based index for modulo to wrap in either
					-- direction, then back to Lua's one-based list index.
					local other = (index - 1 + step) % #panes + 1
					return panes[other]
				end
			end
		end
	end
end

-- Layout leaves are pane IDs; internal nodes divide space into two subtrees.
-- Rex's pane order visits the entire before subtree, then the after subtree.
-- For a horizontal split, before is left; for a vertical split, it is above.
collect_panes = function(node, panes)
	if node.block_id then
		panes[#panes + 1] = node.block_id
	elseif node.split then
		collect_panes(node.split.before, panes)
		collect_panes(node.split.after, panes)
	end
end
