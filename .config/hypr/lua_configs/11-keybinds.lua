-- Keybinds

local home = os.getenv("HOME")
local scriptsDir = home .. "/.config/hypr/scripts"
local mainMod = "SUPER"

-- Session controls
-- hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("hyprctl dispatch exit 0"))
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd(scriptsDir .. "/LockScreen.sh"))
hl.bind("CTRL + ALT + P", hl.dsp.exec_cmd(scriptsDir .. "/Wlogout.sh"))

-- Window operations
hl.bind(mainMod .. " + C", hl.dsp.window.kill())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("zen-browser"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd(scriptsDir .. "/KillActiveProcess.sh"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("pcmanfm-qt"))
hl.bind(mainMod .. " + ALT + F", hl.dsp.exec_cmd("hyprctl dispatch workspaceopt allfloat"))

-- Features / Extras
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd(scriptsDir .. "/Refresh.sh"))
hl.bind(mainMod .. " + ALT + E", hl.dsp.exec_cmd(scriptsDir .. "/RofiEmoji.sh"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(scriptsDir .. "/RofiSearch.sh"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(scriptsDir .. "/ChangeBlur.sh"))
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd(scriptsDir .. "/ChangeLayout.sh"))
hl.bind(mainMod .. " + ALT + V", hl.dsp.exec_cmd(scriptsDir .. "/ClipManager.sh"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("swaync-client -t -sw"))

-- Screen drawing
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("gromit-mpx"))

-- Waybar / Bar related
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd(scriptsDir .. "/WaybarStyles.sh"))
hl.bind(mainMod .. " + ALT + B", hl.dsp.exec_cmd(scriptsDir .. "/WaybarLayout.sh"))

-- Master Layout - use hl.dsp.layout for layoutmsg
hl.bind(mainMod .. " + CTRL + D", hl.dsp.layout("removemaster"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + CTRL + Return", hl.dsp.layout("swapwithmaster"))

-- Group management
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.group.next())

  -- Cycle windows and bring to top (original had two binds on ALT+Tab)
  hl.bind("ALT + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
  end)

-- Special Keys / Hot Keys (with repeat/lock for hold behavior)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --inc"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --dec"), { repeating = true, locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --toggle-mic"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --toggle"), { locked = true })
hl.bind("XF86Sleep", hl.dsp.exec_cmd("systemctl suspend"), { locked = true })
hl.bind("XF86Rfkill", hl.dsp.exec_cmd(scriptsDir .. "/AirplaneMode.sh"), { locked = true })

-- Media controls
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --nxt"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --prv"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --stop"), { locked = true })

-- Screenshots
hl.bind("Print",
    hl.dsp.exec_cmd("hyprshot -m output --freeze -f \"$(date +'%Y-%m-%d_%H.%M.%S').png\" -o " ..
        home .. "/Pictures/Screenshots"))
hl.bind(mainMod .. " + Print",
    hl.dsp.exec_cmd("hyprshot -m window --freeze -f \"$(date +'%Y-%m-%d_%H.%M.%S').png\" -o " ..
        home .. "/Pictures/Screenshots"))
hl.bind("SHIFT + Print",
    hl.dsp.exec_cmd("hyprshot -m region --freeze -f \"$(date +'%Y-%m-%d_%H.%M.%S').png\" -o " ..
        home .. "/Pictures/Screenshots"))

-- Clipboard screenshots
hl.bind("CTRL + Print", hl.dsp.exec_cmd("hyprshot -m output --freeze --clipboard-only"))
hl.bind("CTRL + " .. mainMod .. " + Print", hl.dsp.exec_cmd("hyprshot -m window --freeze --clipboard-only"))
hl.bind("CTRL + SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region --freeze --clipboard-only"))

-- Resize windows (using exec_cmd with hyprctl since resizeactive doesn't exist in Lua)
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -50 0"), { repeating = true })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 50 0"), { repeating = true })
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -50"), { repeating = true })
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 50"), { repeating = true })

-- Move windows using window.move with direction
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.move({ direction = "d" }))

-- Move focus using focus with direction
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Workspace navigation using focus with workspace
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }))

-- Special workspace using workspace.toggle_special
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + U", hl.dsp.workspace.toggle_special(""))

-- Switch workspaces with code:XX for keyboard layout independence
hl.bind(mainMod .. " + code:10", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + code:11", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + code:12", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + code:13", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + code:14", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + code:15", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + code:16", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + code:17", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + code:18", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + code:19", hl.dsp.focus({ workspace = 10 }))

-- Move to workspace using window.move with workspace
hl.bind(mainMod .. " + SHIFT + code:10", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + code:11", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + code:12", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + code:13", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + code:14", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + code:15", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + code:16", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + code:17", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + code:18", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + code:19", hl.dsp.window.move({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + bracketleft", hl.dsp.window.move({ workspace = "-1" }))
hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = "+1" }))

-- Move to workspace silently using window.move with silent=true
hl.bind(mainMod .. " + CTRL + code:10", hl.dsp.window.move({ workspace = 1, follow = false }))
hl.bind(mainMod .. " + CTRL + code:11", hl.dsp.window.move({ workspace = 2, follow = false }))
hl.bind(mainMod .. " + CTRL + code:12", hl.dsp.window.move({ workspace = 3, follow = false }))
hl.bind(mainMod .. " + CTRL + code:13", hl.dsp.window.move({ workspace = 4, follow = false }))
hl.bind(mainMod .. " + CTRL + code:14", hl.dsp.window.move({ workspace = 5, follow = false }))
hl.bind(mainMod .. " + CTRL + code:15", hl.dsp.window.move({ workspace = 6, follow = false }))
hl.bind(mainMod .. " + CTRL + code:16", hl.dsp.window.move({ workspace = 7, follow = false }))
hl.bind(mainMod .. " + CTRL + code:17", hl.dsp.window.move({ workspace = 8, follow = false }))
hl.bind(mainMod .. " + CTRL + code:18", hl.dsp.window.move({ workspace = 9, follow = false }))
hl.bind(mainMod .. " + CTRL + code:19", hl.dsp.window.move({ workspace = 10, follow = false }))
hl.bind(mainMod .. " + CTRL + bracketleft", hl.dsp.window.move({ workspace = "-1", follow = false }))
hl.bind(mainMod .. " + CTRL + bracketright", hl.dsp.window.move({ workspace = "+1", follow = false }))

-- Scroll workspaces with mouse using focus with workspace expression
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + period", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + comma", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse binds for window movement and resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Fullscreen using window.fullscreen with mode
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + CTRL + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
