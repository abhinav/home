S.configAll({
    "defaultToCurrentScreen": true,
    "nudgePercentOf": "screenSize",
    "resizePercentOf": "screenSize",
});

var screenSaverCommand = "/usr/bin/open -a /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app";

// Halves and full screen
S.bindAll({
    "left:alt;cmd": S.op("move", {"x": "screenOriginX",
                                  "y": "screenOriginY",
                                  "width": "screenSizeX/2",
                                  "height": "screenSizeY"}),
    "right:alt;cmd": S.op("move", {"x": "screenOriginX+screenSizeX/2",
                                   "y": "screenOriginY",
                                   "width": "screenSizeX/2",
                                   "height": "screenSizeY"}),
    "up:alt;cmd": S.op("move", {"x": "screenOriginX",
                                   "y": "screenOriginY",
                                   "width": "screenSizeX",
                                   "height": "screenSizeY/2"}),
    "down:alt;cmd": S.op("move", {"x": "screenOriginX",
                                   "y": "screenOriginY+screenSizeY/2",
                                   "width": "screenSizeX",
                                   "height": "screenSizeY/2"}),
    "f:alt;cmd": S.op("move", {"x": "screenOriginX",
                               "y": "screenOriginY",
                               "width": "screenSizeX",
                               "height": "screenSizeY"})
});

// Resize
S.bindAll({
    "right:alt;ctrl;cmd": S.op("resize", {"width": "+10%", "height": "+0"}),
    "left:alt;ctrl;cmd": S.op("resize", {"width": "-10%", "height": "+0"}),
    "down:alt;ctrl;cmd": S.op("resize", {"width": "+0", "height": "+10%"}),
    "up:alt;ctrl;cmd": S.op("resize", {"width": "+0", "height": "-10%"})
});

// Move
S.bindAll({
    "right:alt;ctrl": S.op("nudge", {"x": "+5%", "y": "+0"}),
    "left:alt;ctrl": S.op("nudge", {"x": "-5%", "y": "+0"}),
    "down:alt;ctrl": S.op("nudge", {"x": "+0", "y": "+5%"}),
    "up:alt;ctrl": S.op("nudge", {"x": "+0", "y": "-5%"})
});

// Move between screens 
S.bindAll({
    "right:ctrl;shift;alt": S.op("throw", {"screen": "right"}),
    "left:ctrl;shift;alt": S.op("throw", {"screen": "left"})
});

// Lock screen
S.bind("l:ctrl;cmd", S.op("shell", {"command": screenSaverCommand}));

// Grid
S.bind("space:cmd;shift", S.op("grid", {
    "grids": {
        "0": {"width": 6, "height": 2},
        "1": {"width": 6, "height": 2}
    }
}));

