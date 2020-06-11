-- Disables unintentional hiding of windows.

local function noop()
end

hs.hotkey.bind({'cmd'}, 'H', noop)
hs.hotkey.bind({'cmd', 'alt'}, 'H', noop)
