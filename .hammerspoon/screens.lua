local exports = {}

local directions = {
    up = {'toNorth', 'toSouth'},
    down = {'toSouth', 'toNorth'},
    left = {'toWest', 'toEast'},
    right = {'toEast', 'toWest'},
}

function exports.inDirection(screen, name)
    local direction = directions[name][1]
    local oppositeDirection = directions[name][2]

    if screen[direction](screen) == nil then
        while screen[oppositeDirection](screen) ~= nil do
            screen = screen[oppositeDirection](screen)
        end
    else
        screen = screen[direction](screen)
    end
    return screen
end

return exports
