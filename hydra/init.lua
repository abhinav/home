require "section"

autolaunch.set(true)
hydra.putindock(false)

-----------------------------------------------------------------------------
-- Menu
-----------------------------------------------------------------------------
menu.show(function()
    return {
        {title = "Reload Config", fn = hydra.reload},
        {title = "Open REPL", fn = repl.open},
        {title = "Show logs", fn = logger.show},
        {title = "-"},
        {title = "Quit", fn = os.exit}
    }
end)

-----------------------------------------------------------------------------
-- Sections
-----------------------------------------------------------------------------
ext.default_sections = {
    up = "top",
    right = "right",
    down = "bottom",
    left = "left",
    f = "full"
}

ext.section_transitions = {
    top = {
        left = "top_left",
        right = "top_right"
    },
    right = {
        up = "top_right",
        down = "bottom_right"
    },
    bottom = {
        left = "bottom_left",
        right = "bottom_right"
    },
    left = {
        up = "top_left",
        down = "bottom_left"
    }
}

fnutils.each({"up", "down", "left", "right", 'f'}, function(direction)
    local default = ext.default_sections[direction]
    hotkey.bind({"cmd", "alt"}, direction, function()
        local win = window.focusedwindow()
        local section = ext.section.get(win)
        if section == nil then
            ext.section.set(win, default)
            return
        end

        local transitions = ext.section_transitions[section]
        if transitions == nil then
            ext.section.set(win, default)
            return
        end

        local new_section = transitions[direction]
        if new_section == nil then
            ext.section.set(win, default)
            return
        end

        ext.section.set(win, new_section)
    end)
end)

-----------------------------------------------------------------------------
-- Resize
-----------------------------------------------------------------------------
ext.resizes = {
    up = ext.grid.resizewindow_shorter,
    down = ext.grid.resizewindow_taller,
    left = ext.grid.resizewindow_thinner,
    right = ext.grid.resizewindow_wider
}
fnutils.each({"up", "down", "left", "right"}, function(direction)
    hotkey.bind({"ctrl", "alt", "cmd"}, direction, ext.resizes[direction])
end)

-----------------------------------------------------------------------------
-- Nudge
-----------------------------------------------------------------------------
fnutils.each({"up", "down", "left", "right"}, function(direction)
    hotkey.bind({"ctrl", "alt"}, direction, ext.grid["pushwindow_" .. direction])
end)

-----------------------------------------------------------------------------
-- Move between screens
-----------------------------------------------------------------------------
hotkey.bind({"ctrl", "alt", "shift"}, 'right', ext.grid.pushwindow_nextscreen)
hotkey.bind({"ctrl", "alt", "shift"}, 'left', ext.grid.pushwindow_prevscreen)

-----------------------------------------------------------------------------
-- Screen lock
-----------------------------------------------------------------------------
local screensaver = "/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"
hotkey.bind({"ctrl", "cmd"}, 'L', function()
    application.launchorfocus(screensaver)
end)
