local grid = hs.grid.getGrid()
local GRIDWIDTH = grid.w
local GRIDHEIGHT = grid.h

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

function sectionResizer(direction, defaultSection)
    return function()
        local win = hs.window.focusedWindow()
        if win == nil then
            return
        end

        local sec = section.get(win)
        if sec == nil then
            section.set(win, defaultSection)
            return
        end

        local transitions = section.transitions[sec]
        if transitions == nil then
            section.set(win, defaultSection)
            return
        end

        local target = transitions[direction]
        if target == nil then
            section.set(win, defaultSection)
            return
        end

        section.set(win, target)
    end
end

for direction, default in pairs(section.defaults) do
    hs.hotkey.bind(
        {'cmd', 'alt'}, direction, sectionResizer(direction, default))
end
