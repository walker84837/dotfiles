-- Decoration Settings (Lua version of user_settings.conf - decoration section)
-- Compatible with Hyprland 0.55+

local theme = dofile(os.getenv("HOME") .. "/.config/hypr/lua_configs/theme.lua")
theme.load()

hl.config({
    decoration = {
        rounding = 10,

        active_opacity = 1.0,
        inactive_opacity = 0.9,
        fullscreen_opacity = 1.0,

        dim_inactive = true,
        dim_strength = 0.1,
        dim_special = 0.8,

        blur = {
            enabled = true,
            size = 6,
            passes = 2,
            ignore_opacity = true,
            new_optimizations = true,
            special = true
        },

        shadow = {
            enabled = true,
            range = 3,
            render_power = 1,
            color = theme.hex_prefixed_alpha("color12", "ff"),
            color_inactive = 0x50000000
        }
    }
})
