local screens = require('screens')

local function round(num)
    return math.floor(num + 0.5)
end

local function focusScreen(direction)
    return function()
        local fromScreen = hs.window.focusedWindow():screen()
        local toScreen = screens.inDirection(fromScreen, direction)
        if toScreen == nil then
            return
        end

        local win = hs.window.desktop()
        for _, w in pairs(hs.window.orderedWindows()) do
            if w:screen() == toScreen then
                win = w
                break
            end
        end

        local mouseScreen = hs.mouse.getCurrentScreen()
        local pos = hs.mouse.getRelativePosition()
        pos.x = round((pos.x / mouseScreen:frame().w) * toScreen:frame().w)
        pos.y = round((pos.y / mouseScreen:frame().h) * toScreen:frame().h)

        hs.mouse.setRelativePosition(pos, toScreen)
        win:focus()
    end
end

local directions = {
    h = 'left',
    l = 'right',
}

for k, dir in pairs(directions) do
    hs.hotkey.bind({'command', 'shift'}, k, focusScreen(dir))
end
