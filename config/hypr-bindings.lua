-- omarchy-setup keybinding customizations.
-- The installer appends this to ~/.config/hypr/bindings.lua

-- On-screen keyboard (wvkbd) toggle
o.bind("SUPER + CTRL + SHIFT + K", "On-screen keyboard", "pkill wvkbd-mobintl || ~/.local/bin/wvkbd-mobintl -L 300")

-- Swap: SUPER+F = full width, SUPER+ALT+F = full screen
hl.unbind("SUPER + F")
hl.unbind("SUPER + ALT + F")
o.bind("SUPER + F", "Full width", hl.dsp.window.fullscreen({ mode = "maximized" }))
o.bind("SUPER + ALT + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- Super+Enter opens the terminal in ~/tmp by default (instead of home)
hl.unbind("SUPER + RETURN")
o.bind("SUPER + RETURN", "Terminal", os.getenv("HOME") .. "/.local/bin/omarchy-terminal-tmp")

-- Super+N opens a quick note (GNOME Text Editor, keeps text without saving)
o.bind("SUPER + N", "Quick note", "uwsm-app -- gnome-text-editor")

-- Sleep the laptop when the lid is closed, unless an external monitor is attached.
-- Replaces Omarchy's lock-only lid handler (Hyprland runs only one handler per switch).
hl.unbind("switch:on:Lid Switch")
o.bind("switch:on:Lid Switch", nil, os.getenv("HOME") .. "/.local/bin/omarchy-lid-suspend", { locked = true })
