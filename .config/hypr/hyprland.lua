-- Main Hyprland Lua Configuration

-- Load theme colors from wallust
local theme = dofile(os.getenv("HOME") .. "/.config/hypr/lua_configs/theme.lua")
local colors = theme.load()

-- Environment variables
require("lua_configs.01-env")

-- Monitor configuration
require("lua_configs.02-monitors")

-- General settings (colors from wallust are substituted in the file)
require("lua_configs.03-general")

-- Decoration settings
require("lua_configs.04-decoration")

-- Animation settings (bezier curves and animations)
require("lua_configs.05-animations")

-- Layout settings
require("lua_configs.06-layouts")

-- Misc, cursor, group settings
require("lua_configs.07-misc")

-- Input and binds settings
require("lua_configs.08-input")

-- Window rules
require("lua_configs.09-windowrules")

-- Workspace rules
require("lua_configs.10-workspacerules")

-- Keybinds
require("lua_configs.11-keybinds")

-- User keybinds
require("lua_configs.12-user_keybinds")

-- Autostart
require("lua_configs.13-autostart")

print("Hyprland Lua configuration loaded successfully")

