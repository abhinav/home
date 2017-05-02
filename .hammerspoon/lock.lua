-- Screen lock

local screensaver = '/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app'

local function screenLock()
    hs.application.launchOrFocus(screensaver)
end

hs.hotkey.bind({'ctrl', 'cmd'}, 'L', screenLock)
