local application = require "mjolnir.application"
local hotkey = require "mjolnir.hotkey"
local window = require "mjolnir.window"
local fnutils = require "mjolnir.fnutils"
local grid = require "mjolnir.bg.grid"

-- Reconfigure the grid.
grid.GRIDHEIGHT = 20
grid.GRIDWIDTH = 20
grid.MARGINX = 0
grid.MARGINY = 0

-----------------------------------------------------------------------------
-- Resizes and nudges
-----------------------------------------------------------------------------
local resizes = {
    up = grid.resizewindow_shorter,
    down = grid.resizewindow_taller,
    left = grid.resizewindow_thinner,
    right = grid.resizewindow_wider
}

fnutils.each({"up", "down", "left", "right"}, function(direction)
    hotkey.bind({"ctrl", "alt", "cmd"}, direction, resizes[direction])
    hotkey.bind({"ctrl", "alt"}, direction, grid["pushwindow_" .. direction])
end)

-----------------------------------------------------------------------------
-- Move between screens
-----------------------------------------------------------------------------
local screen_moves = {
    left = grid.pushwindow_nextscreen,
    right = grid.pushwindow_prevscreen
}

for direction, mover in pairs(screen_moves) do
    hotkey.bind({"ctrl", "alt", "shift"}, direction, mover)
end

-----------------------------------------------------------------------------
-- Screen lock
-----------------------------------------------------------------------------
local screensaver = "/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"
hotkey.bind({"ctrl", "cmd"}, "L", function()
    application.launchorfocus(screensaver)
end)

-----------------------------------------------------------------------------
-- Sections
-----------------------------------------------------------------------------
local function round(num)
    return math.floor(num + 0.5)
end

local GRIDWIDTH_HALF = round(grid.GRIDWIDTH / 2)
local GRIDHEIGHT_HALF = round(grid.GRIDHEIGHT / 2)

-- Different sections of the screen that a window can take.
local SECTIONS = {
    top_left = {
        x = 0,
        y = 0,
        w = GRIDWIDTH_HALF,
        h = GRIDHEIGHT_HALF
    },
    top = {
        x = 0,
        y = 0,
        w = grid.GRIDWIDTH,
        h = GRIDHEIGHT_HALF
    },
    top_right = {
        x = GRIDWIDTH_HALF,
        y = 0,
        w = GRIDWIDTH_HALF,
        h = GRIDHEIGHT_HALF
    },
    right = {
        x = GRIDWIDTH_HALF,
        y = 0,
        w = GRIDWIDTH_HALF,
        h = grid.GRIDHEIGHT
    },
    right_third = {
        x = round(2 * grid.GRIDWIDTH / 3),
        y = 0,
        w = round(grid.GRIDWIDTH / 3),
        h = grid.GRIDHEIGHT
    },
    bottom_right = {
        x = GRIDWIDTH_HALF,
        y = GRIDHEIGHT_HALF,
        w = GRIDWIDTH_HALF,
        h = GRIDHEIGHT_HALF
    },
    bottom = {
        x = 0,
        y = GRIDHEIGHT_HALF,
        w = grid.GRIDWIDTH,
        h = GRIDHEIGHT_HALF
    },
    bottom_left = {
        x = 0,
        y = GRIDHEIGHT_HALF,
        w = GRIDWIDTH_HALF,
        h = GRIDHEIGHT_HALF
    },
    left = {
        x = 0,
        y = 0,
        w = GRIDWIDTH_HALF,
        h = grid.GRIDHEIGHT
    },
    left_third = {
        x = 0,
        y = 0,
        w = round(grid.GRIDWIDTH / 3),
        h = grid.GRIDHEIGHT
    },
    full = {
        x = 0,
        y = 0,
        w = grid.GRIDWIDTH,
        h = grid.GRIDHEIGHT
    },
    center_third = {
        x = round(grid.GRIDWIDTH / 3),
        y = 0,
        w = round(grid.GRIDWIDTH / 3),
        h = grid.GRIDHEIGHT
    }
}

local section = {}

-- Returns the name of the section mostly occupied by the given window, if
-- any.
function section.get(win)
    local current = grid.get(win)
    for name, section in pairs(SECTIONS) do
        local match = true
        for k, v in pairs(section) do
            if v ~= current[k] then
                match = false
                break
            end
        end

        if match then
            return name
        end
    end
    return nil
end

-- Moves and resizes the given window to occupy the given section.
function section.set(win, name)
    local new_grid = SECTIONS[name]
    if new_grid ~= nil then
        grid.set(win, new_grid, win:screen())
    end
end

-----------------------------------------------------------------------------
-- Section mappings
-----------------------------------------------------------------------------

-- Map of default sections to which the given keys map.
local default_sections = {
    up = "top",
    right = "right",
    down = "bottom",
    left = "left",
    f = "full"
}

-- Maps current sections to transitions supported by it. A transition is an
-- entry in the map that indicates that the current section transitions into
-- the new section if the given key is pressed.
local section_transitions = {
    top = {
        left = "top_left",
        right = "top_right"
    },
    right = {
        up = "top_right",
        down = "bottom_right",
        right = "right_third"
    },
    bottom = {
        left = "bottom_left",
        right = "bottom_right"
    },
    left = {
        up = "top_left",
        down = "bottom_left",
        left = "left_third"
    },
    full = {
        f = "center_third"
    }
}

for key, default in pairs(default_sections) do
    hotkey.bind({"cmd", "alt"}, key, function()
        local win = window.focusedwindow()
        if win == nil then
            return
        end

        local current_section = section.get(win)
        if current_section == nil then
            section.set(win, default)
            return
        end

        local transitions = section_transitions[current_section]
        if transitions == nil then
            section.set(win, default)
            return
        end

        local new_section = transitions[key]
        if new_section == nil then
            section.set(win, default)
            return
        end

        section.set(win, new_section)
    end)
end
