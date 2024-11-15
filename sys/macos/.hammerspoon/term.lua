-- Terminal customizations

local function newTerminal()
    local ghostty = hs.application.find('Ghostty')
    if ghostty == nil then
        hs.application.launchOrFocus('Ghostty')
    else
        ghostty:selectMenuItem({'File', 'New Window'})
    end
end

hs.hotkey.bind({'alt', 'shift'}, 'return', newTerminal)
