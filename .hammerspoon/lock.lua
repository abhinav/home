-- Screen lock

local screensaver = '/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app'

local function screenLock()
    hs.alert("Locking")
    hs.timer.doAfter(1, function()
        hs.application.launchOrFocus(screensaver)
    end)
end

hs.hotkey.bind({'ctrl', 'cmd'}, 'L', screenLock)
