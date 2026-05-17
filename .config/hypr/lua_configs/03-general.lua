local theme = dofile(os.getenv("HOME") .. "/.config/hypr/lua_configs/theme.lua")
theme.load()

hl.config({
    general = {
        border_size = 2,
        gaps_in = 5,
        gaps_out = 20,
        resize_on_border = true,
        ["col.active_border"] = theme.rgba("color12", "cc"),
        ["col.inactive_border"] = theme.rgba("color12", "cc"),
        layout = "dwindle"
    }
})
