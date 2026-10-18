require("pane_cycle")
local bind = require("tmux_bind")

bind("ctrl+b>ctrl+b", "pane.send_key", { key = "ctrl+b" })
bind("ctrl+b>shift+r", "client.config.reload")

-- [hold Ctrl] b \   Vertical   split
-- [hold Ctrl] b /   Horizontal split
bind("ctrl+b>ctrl+\\", "pane.split", { direction = "right" })
bind("ctrl+b>ctrl+/", "pane.split", { direction = "down" })

-- [hold Ctrl] b h   Resize left
-- [hold Ctrl] b j   Resize down
-- [hold Ctrl] b k   Resize up
-- [hold Ctrl] b l   Resize right
bind("ctrl+b>ctrl+h", "pane.resize", { direction = "left", amount = 10 })
bind("ctrl+b>ctrl+j", "pane.resize", { direction = "down", amount = 10 })
bind("ctrl+b>ctrl+k", "pane.resize", { direction = "up", amount = 10 })
bind("ctrl+b>ctrl+l", "pane.resize", { direction = "right", amount = 10 })

-- Ctrl b + <    Extract pane into a new tab
-- Ctrl b + >    Move pane into an existing tab
bind("ctrl+b>shift+,", "pane.move_to_new_tab")
bind("ctrl+b>shift+.", "pane.move_to_tab")

-- Ctrl b + ^    Session switcher
bind("ctrl+b>shift+6", "session.switch")

-- Ctrl b + c    New tab
-- Ctrl b + n    Next tab
-- Ctrl b + p    Previous tab
-- Ctrl b + ,    Rename tab
-- Ctrl b + x    Close pane
bind("ctrl+b>c", "client.tab.new")
bind("ctrl+b>n", "client.tab.next")
bind("ctrl+b>p", "client.tab.previous")
bind("ctrl+b>,", "client.tab.rename")
bind("ctrl+b>x", "pane.close")

-- Ctrl b + z    Toggle zoom
bind("ctrl+b>z", "pane.zoom")

-- Ctrl b + }    Swap with the next pane, wrapping at the end
-- Ctrl b + {    Swap with the previous pane, wrapping at the start
bind("ctrl+b>shift+]", "cycle_pane", { step = 1 })
bind("ctrl+b>shift+[", "cycle_pane", { step = -1 })
