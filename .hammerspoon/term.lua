-- Terminal customizations

local function newTerminal()
    if hs.application.find('iTerm') == nil then
        hs.application.launchOrFocus('iTerm')
    else
        hs.applescript.applescript([[
            tell application "iTerm"
                create window with default profile
            end tell
        ]])
    end
end

hs.hotkey.bind({'alt', 'shift'}, 'return', newTerminal)
