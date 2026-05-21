-- Terminal customizations

local function newTerminal()
    local iterm = hs.application.find('iTerm2')
    if iterm == nil then
        hs.application.launchOrFocus('iTerm2')
    else
        iterm:selectMenuItem({'Shell', 'New Window'})
    end
end

hs.hotkey.bind({'alt', 'shift'}, 'return', newTerminal)
