require "grid"

local function round(num)
    return math.floor(num + 0.5)
end

local GRIDWIDTH_HALF = round(ext.grid.GRIDWIDTH / 2)
local GRIDHEIGHT_HALF = round(ext.grid.GRIDHEIGHT / 2)
local GRIDS = {
    top_left = {
        x = 0,
        y = 0,
        w = GRIDWIDTH_HALF,
        h = GRIDHEIGHT_HALF
    },
    top = {
        x = 0,
        y = 0,
        w = ext.grid.GRIDWIDTH,
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
        h = ext.grid.GRIDHEIGHT
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
        w = ext.grid.GRIDWIDTH,
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
        h = ext.grid.GRIDHEIGHT
    },
    full = {
        x = 0,
        y = 0,
        w = ext.grid.GRIDWIDTH,
        h = ext.grid.GRIDHEIGHT
    }
}

ext.section = {}

function ext.section.get(win)
    local f = ext.grid.get(win)
    for name, g in pairs(GRIDS) do
        local match = true
        for k, v in pairs(g) do
            if v ~= f[k] then
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

function ext.section.set(win, name)
    local g = GRIDS[name]
    if g ~= nil then
        ext.grid.set(win, g, win:screen())
    end
end
