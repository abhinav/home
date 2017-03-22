-- Basic window management setup

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

-- Returns a function that moves the current window in the current direction,
-- or wraps to the further most window in the opposite direction if there are
-- no more screens in the given direction.
--
-- direction and oppositeDirection must be names of methods on hs.screen
-- objects.
local function screenMover(direction, oppositeDirection)
    return function()
        local win = hs.window.focusedWindow()
        local screen = win:screen()
        if screen[direction](screen) == nil then
            while screen[oppositeDirection](screen) ~= nil do
                screen = screen[oppositeDirection](screen)
            end
        else
            screen = screen[direction](screen)
        end
        hs.grid.set(win, hs.grid.get(win), screen)
    end
end

hs.hotkey.bind(
    {'ctrl', 'alt', 'shift'}, 'left', screenMover('toWest', 'toEast'))
hs.hotkey.bind(
    {'ctrl', 'alt', 'shift'}, 'right', screenMover('toEast', 'toWest'))
