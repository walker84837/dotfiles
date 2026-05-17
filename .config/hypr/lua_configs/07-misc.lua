-- Misc, Cursor, and Group Settings
-- Compatible with Hyprland 0.55+

local theme = dofile(os.getenv("HOME") .. "/.config/hypr/lua_configs/theme.lua")
theme.load()

hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms = true,
        enable_swallow = true,
        swallow_regex = "^(kitty)$",
        focus_on_activate = false,
        initial_workspace_tracking = 0,
        middle_click_paste = false
    }
})

hl.config({
    cursor = {
        enable_hyprcursor = true,
        warp_on_change_workspace = true
    }
})

hl.config({
    group = {
        ["col.border_active"] = theme.rgba("color15", "aa"),
        groupbar = {
            ["col.active"] = theme.rgba("color0", "cc")
        }
    }
})
