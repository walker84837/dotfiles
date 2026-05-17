-- User Keybinds

local home = os.getenv("HOME")
local scriptsDir = home .. "/.config/hypr/scripts"
local userScripts = home .. "/.config/hypr/UserScripts"
local mainMod = "SUPER"
local term = "kitty"

-- Rofi App launcher
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("pkill rofi || rofi -show drun -modi drun,filebrowser,run,window"))

-- ags overview
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("pkill rofi || true && ags -t 'overview'"))

-- Terminal
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(term))

-- Calculator
hl.bind(mainMod .. " + ALT + C", hl.dsp.exec_cmd(userScripts .. "/RofiCalc.sh"))

-- pyprland dropdown terminal
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("pypr toggle term"))

-- pyprland zoom
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("pypr zoom"))

-- Change oh-my-zsh theme
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd(userScripts .. "/ZshChangeTheme.sh"))

-- Switch keyboard layout (bindn = bind without consuming)
hl.bind("ALT_L + SHIFT_L", hl.dsp.exec_cmd(scriptsDir .. "/SwitchKeyboardLayout.sh"), { non_consuming = true })

-- Theme switcher (dunst, kitty, GTK, Qt, wallust, waybar)
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd(scriptsDir .. "/darklight.js"))

-- Music player (online streams + local library)
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd(scriptsDir .. "/rofibeats.js"))

-- Wallpaper effects (ImageMagick filters via swww)
hl.bind(mainMod .. " + ALT + X", hl.dsp.exec_cmd(scriptsDir .. "/wallpaper-effects.js"))
