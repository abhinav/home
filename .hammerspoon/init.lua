-- Keybindings:
--
-- ctrl-cmd + L
--      Start the screen saver.
--
-- ctrl-alt + up/down/left/right
--      Move a window in the specified direction.
--
-- ctrl-alt-cmd + up/down/left/right
--      Resize the window in the specified direction while keeping the
--      top-left anchored.
--
-- ctrl-alt-shift + left/right
--      Move the window to the next/previous screen while maintaining its size
--      relative to that screen's grid.
--
-- cmd-shift + h/l
--      Move the mouse to the screen in the given direction placing it in the
--      same section of the new screen as the original.
--
-- cmd-alt + up/down/left/right
--      Resize the current window to take the given half of the screen. For
--      left/right, if the window was already in that half, take that third of
--      the screen.
--
-- cmd-alt + f
--      Resize the window to take the full screen. If the window was already
--      taking the full screen, resize it to take a third of center third of
--      the screen horizontally while remaining vertically full sized.
--
-- alt-shift-enter
--      Create a new iTerm window.

-----------------------------------------------------------------------------
-- Reload automatically when this file changes
-----------------------------------------------------------------------------

local function reload(files)
    local shouldReload = false
    for _, file in pairs(files) do
        if file:sub(-4) == '.lua' then
            shouldReload = true
        end
    end
    if shouldReload then
        hs.reload()
    end
end

hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reload):start()

-----------------------------------------------------------------------------
-- Global configuration
-----------------------------------------------------------------------------

-- Set up grid
local GRIDWIDTH = 12
local GRIDHEIGHT = 12
hs.grid.setGrid(GRIDWIDTH .. 'x' .. GRIDHEIGHT)
hs.grid.setMargins({w = 0, h = 0})
hs.grid.ui.textSize = 16

-- No animations
hs.window.animationDuration = 0

require('win')
require('mouse')
require('term')
require('lock')
require('sections')
