S.configAll({
    "defaultToCurrentScreen": true,
    "nudgePercentOf": "screenSize",
    "resizePercentOf": "screenSize",
});

var screenSaverCommand = "/usr/bin/open -a /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app";

// States:
// +-------------+----------+--------------+
// | top-left    |  top     | top-right    |
// +-------------+----------+--------------+
// | left        |          | right        |
// +-------------+----------+--------------+
// | bottom-left |  bottom  | bottom-right |
// +-------------+----------+--------------+
var states = {};

_.each(["windowOpened", "windowFocused"], function(eventName) {
    S.on(eventName, function(e, w) {
        delete states[w.app().name()];
    });
});

_.each(["windowClosed", "appClosed", "appOpened"], function(eventName) {
    S.on(eventName, function(e, a) {
        delete states[a.name()];
    });
});

var operations = {
    "top-left": S.op("move", {"x": "screenOriginX", "y": "screenOriginY", "width": "screenSizeX/2", "height": "screenSizeY/2"}),
    "top": S.op("move", {"x": "screenOriginX", "y": "screenOriginY", "width": "screenSizeX", "height": "screenSizeY/2"}),
    "top-right": S.op("move", {"x": "screenOriginX+screenSizeX/2", "y": "screenOriginY", "width": "screenSizeX/2", "height": "screenSizeY/2"}),
    "right": S.op("move", {"x": "screenOriginX+screenSizeX/2", "y": "screenOriginY", "width": "screenSizeX/2", "height": "screenSizeY"}),
    "bottom-right": S.op("move", {"x": "screenOriginX+screenSizeX/2", "y": "screenOriginY+screenSizeY/2", "width": "screenSizeX/2", "height": "screenSizeY/2"}),
    "bottom": S.op("move", {"x": "screenOriginX", "y": "screenOriginY+screenSizeY/2", "width": "screenSizeX", "height": "screenSizeY/2"}),
    "bottom-left": S.op("move", {"x": "screenOriginX", "y": "screenOriginY+screenSizeY/2", "width": "screenSizeX/2", "height": "screenSizeY/2"}),
    "left": S.op("move", {"x": "screenOriginX", "y": "screenOriginY", "width": "screenSizeX/2", "height": "screenSizeY"}),
    
    "full": S.op("move", {"x": "screenOriginX", "y": "screenOriginY", "width": "screenSizeX", "height": "screenSizeY"}),
};

var defaultTransitions = {
    "up": "top",
    "right": "right",
    "down": "bottom",
    "left": "left",

    "f": "full"
};

// Transitions specific to a state. These override the defaults when in that
// state.
var transitions = {
    "top": {"left": "top-left", "right": "top-right"},
    "right": {"up": "top-right", "down": "bottom-right"},
    "bottom": {"left": "bottom-left", "right": "bottom-right"},
    "left": {"up": "top-left", "down": "bottom-left"}
};

var nextState = function(key, win) {
    var appName = win.app().name();
    if (appName in states) {
        var currentState = states[appName];
        if (currentState != null && currentState in transitions
                && key in transitions[currentState]) {
            return transitions[currentState][key];
        }
    }
    return defaultTransitions[key];
};

var go = function(key) {
    return function(win) {
        var newState = nextState(key, win);
        win.doOperation(operations[newState]);
        states[win.app().name()] = newState;
    };
};

// Halves and full screen
S.bindAll({
    "left:alt;cmd": go("left"),
    "right:alt;cmd": go("right"),
    "up:alt;cmd": go("up"),
    "down:alt;cmd": go("down"),
    "f:alt;cmd": go("f")
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

