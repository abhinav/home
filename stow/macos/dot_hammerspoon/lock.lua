-- Screen lock

local screensaver = 'ScreenSaverEngine'

local function screenLock()
    hs.application.launchOrFocus(screensaver)
end

hs.hotkey.bind({'ctrl', 'cmd'}, 'L', screenLock)
