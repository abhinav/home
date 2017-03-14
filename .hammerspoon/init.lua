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

-----------------------------------------------------------------------------
-- Basic window movement and resizing
-----------------------------------------------------------------------------

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

-- move to next/prev screens
hs.hotkey.bind({'ctrl', 'alt', 'shift'}, 'left', function()
    local win = hs.window.focusedWindow()
    local screen = win:screen()
    if screen:toWest() == nil then
        while screen:toEast() ~= nil do
            screen = screen:toEast()
        end
    else
        screen = screen:toWest()
    end
    hs.grid.set(win, hs.grid.get(win), screen)
end)

hs.hotkey.bind({'ctrl', 'alt', 'shift'}, 'right', function()
    local win = hs.window.focusedWindow()
    local screen = win:screen()
    if screen:toEast() == nil then
        while screen:toWest() ~= nil do
            screen = screen:toWest()
        end
    else
        screen = screen:toEast()
    end
    hs.grid.set(win, hs.grid.get(win), screen)
end)

-----------------------------------------------------------------------------
-- New terminal
-----------------------------------------------------------------------------

hs.hotkey.bind({'alt', 'shift'}, 'return', function()
    if hs.application.find('iTerm') == nil then
        hs.application.launchOrFocus('iTerm')
    else
        hs.applescript.applescript([[
            tell application "iTerm"
                create window with default profile
            end tell
        ]])
    end
end)

-----------------------------------------------------------------------------
-- Screen lock
-----------------------------------------------------------------------------

local screensaver = '/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app'
hs.hotkey.bind({'ctrl', 'cmd'}, 'L', function()
    hs.alert("Locking")
    hs.timer.doAfter(1, function()
        hs.application.launchOrFocus(screensaver)
    end)
end)

-----------------------------------------------------------------------------
-- Screen sectioning
-----------------------------------------------------------------------------

local function round(num)
    return math.floor(num + 0.5)
end

-- Different sections of the screen that a window can take.
local SECTIONS = {
    topLeft = {
        x = 0,
        y = 0,
        w = round(GRIDWIDTH / 2),
        h = round(GRIDHEIGHT / 2)
    },
    top = {
        x = 0,
        y = 0,
        w = GRIDWIDTH,
        h = round(GRIDHEIGHT / 2)
    },
    topThird = {
        x = 0,
        y = 0,
        w = round(GRIDWIDTH),
        h = round(GRIDWIDTH / 3),
    },
    topTwoThird = {
        x = 0,
        y = 0,
        w = round(GRIDWIDTH),
        h = round(GRIDWIDTH / 3) * 2,
    },
    topRight = {
        x = round(GRIDWIDTH / 2),
        y = 0,
        w = round(GRIDWIDTH / 2),
        h = round(GRIDHEIGHT / 2)
    },
    rightTwoThird = {
        x = GRIDWIDTH - round(GRIDWIDTH / 3) * 2,
        y = 0,
        w = round(GRIDWIDTH / 3) * 2,
        h = GRIDHEIGHT
    },
    right = {
        x = round(GRIDWIDTH / 2),
        y = 0,
        w = round(GRIDWIDTH / 2),
        h = GRIDHEIGHT
    },
    rightThird = {
        x = GRIDWIDTH - round(GRIDWIDTH / 3),
        y = 0,
        w = round(GRIDWIDTH / 3),
        h = GRIDHEIGHT
    },
    bottomRight = {
        x = round(GRIDWIDTH / 2),
        y = round(GRIDHEIGHT / 2),
        w = round(GRIDWIDTH / 2),
        h = round(GRIDHEIGHT / 2)
    },
    bottom = {
        x = 0,
        y = round(GRIDHEIGHT / 2),
        w = GRIDWIDTH,
        h = round(GRIDHEIGHT / 2)
    },
    bottomThird = {
        x = 0,
        y = round(GRIDHEIGHT / 3) * 2,
        w = round(GRIDWIDTH),
        h = round(GRIDWIDTH / 3),
    },
    bottomTwoThird = {
        x = 0,
        y = round(GRIDHEIGHT / 3),
        w = round(GRIDWIDTH),
        h = round(GRIDWIDTH / 3) * 2,
    },
    bottomLeft = {
        x = 0,
        y = round(GRIDHEIGHT / 2),
        w = round(GRIDWIDTH / 2),
        h = round(GRIDHEIGHT / 2)
    },
    leftTwoThird = {
        x = 0,
        y = 0,
        w = round(GRIDWIDTH / 3) * 2,
        h = GRIDHEIGHT
    },
    left = {
        x = 0,
        y = 0,
        w = round(GRIDWIDTH / 2),
        h = GRIDHEIGHT
    },
    leftThird = {
        x = 0,
        y = 0,
        w = round(GRIDWIDTH / 3),
        h = GRIDHEIGHT
    },
    full = {
        x = 0,
        y = 0,
        w = GRIDWIDTH,
        h = GRIDHEIGHT
    },
    centerThird = {
        x = round(GRIDWIDTH / 3),
        y = 0,
        w = round(GRIDWIDTH / 3),
        h = GRIDHEIGHT
    },
    middleThird = {
        x = 0,
        y = round(GRIDHEIGHT / 3),
        w = GRIDWIDTH,
        h = round(GRIDHEIGHT / 3)
    },
}

local section = {
    -- default sections to which the given keys map
    defaults = {
        up    = 'top',
        right = 'right',
        down  = 'bottom',
        left  = 'left',
        f     = 'full'
    },
    -- transitions between sections based on the key that was pressed.
    transitions = {
        top = {
            up    = 'topThird',
            left  = 'topLeft',
            right = 'topRight'
        },
        right = {
            up    = 'topRight',
            down  = 'bottomRight',
            right = 'rightThird'
        },
        bottom = {
            left  = 'bottomLeft',
            down  = 'bottomThird',
            right = 'bottomRight'
        },
        left = {
            up   = 'topLeft',
            down = 'bottomLeft',
            left = 'leftThird'
        },
        topThird      = { up    =   'topTwoThird' },
        rightThird    = { right = 'rightTwoThird' },
        rightTwoThird = { right =         'right' },
        bottomThird   = { down  ='bottomTwoThird' },
        leftThird     = { left  =  'leftTwoThird' },
        leftTwoThird  = { left  =          'left' },
        full          = { f     =   'centerThird' },
        centerThird   = { f     =   'middleThird' },
    }
}

-- section.get(win) -> string
--
-- Get the name of the section (as defined in SECTIONS) occupied by the given
-- window or nil if a match wasn't found.
function section.get(win)
    local current = hs.grid.get(win)
    for name, geom in pairs(SECTIONS) do
        if current:equals(geom) then
            return name
        end
    end
    return nil
end

-- section.set(win, name)
--
-- Resize the window to occupy the given section on the same screen.
function section.set(win, name)
    local geom = SECTIONS[name]
    if geom ~= nil then
        hs.grid.set(win, geom, win:screen())
    end
end

for direction, default in pairs(section.defaults) do
    hs.hotkey.bind({'cmd', 'alt'}, direction, function()
        local win = hs.window.focusedWindow()
        if win == nil then
            return
        end

        local sec = section.get(win)
        if sec == nil then
            section.set(win, default)
            return
        end

        local transitions = section.transitions[sec]
        if transitions == nil then
            section.set(win, default)
            return
        end

        local target = transitions[direction]
        if target == nil then
            section.set(win, default)
            return
        end

        section.set(win, target)
    end)
end
