-- Autostart Applications

local scripts_dir = os.getenv("HOME") .. "/.config/hypr/scripts"
-- local user_scripts = os.getenv("HOME") .. "/.config/hypr/UserScripts"

local M = {}

hl.on("hyprland.start", function()
    hl.exec_cmd("awww-daemon --format xrgb")

    hl.exec_cmd("systemctl --user start hyprland-session.target")
    -- D-Bus environment setup
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Polkit (Polkit Gnome / KDE)
    hl.exec_cmd(scripts_dir .. "/Polkit.sh")

    -- Core services
    hl.exec_cmd("waybar")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("dunst")

    -- Idle management
    hl.exec_cmd("hypridle")

    -- Pyprland daemon
    hl.exec_cmd("pypr")
end)

return M
