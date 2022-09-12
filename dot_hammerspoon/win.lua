-- Basic window management setup

local screens = require('screens')

-- resize while keeping top-left anchored
local resizes = {
    up = hs.grid.resizeWindowShorter,
    down = hs.grid.resizeWindowTaller,
    left = hs.grid.resizeWindowThinner,
    right = hs.grid.resizeWindowWider
}

for direction, resizer in pairs(resizes) do
    hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, direction, resizer)
end

-- move while snapping size to grid
local moves = {
    up = hs.grid.pushWindowUp,
    down = hs.grid.pushWindowDown,
    left = hs.grid.pushWindowLeft,
    right = hs.grid.pushWindowRight,
}

for direction, mover in pairs(moves) do
    hs.hotkey.bind({'ctrl', 'alt'}, direction, mover)
end

local function screenMover(direction)
    return function()
        local win = hs.window.focusedWindow()
        local screen = screens.inDirection(win:screen(), direction)
        if screen ~= nil then
            hs.grid.set(win, hs.grid.get(win), screen)
        end
    end
end

local screenMovers = {'left', 'right'}
for k, dir in pairs(screenMovers) do
    hs.hotkey.bind({'ctrl', 'alt', 'shift'}, dir, screenMover(dir))
end

-- move to a different space
local function moveWindowToSpace(offset)
    return function()
        local allSpaces = hs.spaces.spacesForScreen(nil)
        local spaceIdx = hs.fnutils.indexOf(allSpaces, hs.spaces.focusedSpace())
        local targetSpace = allSpaces[spaceIdx + offset]
        if targetSpace ~= nil then
            hs.spaces.moveWindowToSpace(hs.window.focusedWindow(), targetSpace)
            hs.spaces.gotoSpace(targetSpace)
        end
    end
end

local spacers = {h = -1, l = 1}
for k, offset in pairs(spacers) do
    hs.hotkey.bind({'alt', 'shift'}, k, moveWindowToSpace(offset))
end
