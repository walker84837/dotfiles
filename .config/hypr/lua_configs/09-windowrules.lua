-- Window Rules

-- Misc settings
hl.config({
    misc = {
        enable_anr_dialog = false
    }
})

-- Center rules for Thunar dialogs
hl.window_rule({
    name   = "center-thunar-progress",
    match  = { class = "^([Tt]hunar)$", title = "^(File Operation Progress)$" },
    center = true
})
hl.window_rule({
    name   = "center-thunar-confirm",
    match  = { class = "^([Tt]hunar)$", title = "^(Confirm to replace files)$" },
    center = true
})

-- Fullscreen idle inhibit
hl.window_rule({
    name         = "idle-inhibit-fullscreen",
    match        = { fullscreen = true },
    idle_inhibit = "always"
})

-- Float rules
hl.window_rule({ name = "float-kde-polkit", match = { class = "org.kde.polkit-kde-authentication-agent-1" }, float = true })
hl.window_rule({ name = "float-zoom-onedriver", match = { class = "^([Zz]oom|onedriver|onedriver-launcher)$" }, float = true })
hl.window_rule({ name = "float-thunar-progress", match = { class = "^([Tt]hunar)$", title = "^(File Operation Progress)$" }, float = true })
hl.window_rule({ name = "float-thunar-confirm", match = { class = "^([Tt]hunar)$", title = "^(Confirm to replace files)$" }, float = true })
hl.window_rule({ name = "float-xdg-desktop-portal", match = { class = "xdg-desktop-portal-gtk" }, float = true })
hl.window_rule({ name = "float-gnome-calculator", match = { class = "org.gnome.Calculator", title = "^(Calculator)$" }, float = true })
hl.window_rule({ name = "float-codium-workspace", match = { class = "^(codium|codium-url-handler|VSCodium)$", title = "^(Add Folder to Workspace)$" }, float = true })
hl.window_rule({ name = "float-rofi", match = { class = "^([Rr]ofi)$" }, float = true })
hl.window_rule({ name = "float-eog", match = { class = "eog" }, float = true })
hl.window_rule({ name = "float-pavucontrol", match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol)$" }, float = true })
hl.window_rule({ name = "float-nwg-qt", match = { class = "^(nwg-look|qt5ct|qt6ct|mpv)$" }, float = true })
hl.window_rule({ name = "float-nm-blueman", match = { class = "^(nm-applet|nm-connection-editor|blueman-manager)$" }, float = true })
hl.window_rule({ name = "float-gnome-system-monitor", match = { class = "^(gnome-system-monitor|org.gnome.SystemMonitor)$" }, float = true })
hl.window_rule({ name = "float-yad", match = { class = "yad" }, float = true })
hl.window_rule({ name = "float-wihotspot", match = { class = "wihotspot-gui" }, float = true })
hl.window_rule({ name = "float-evince", match = { class = "evince" }, float = true })
hl.window_rule({ name = "float-file-roller", match = { class = "^(file-roller|org.gnome.FileRoller)$" }, float = true })
hl.window_rule({ name = "float-baobab", match = { class = "^([Bb]aobab|org.gnome.[Bb]aobab)$" }, float = true })
hl.window_rule({ name = "float-kvantum", match = { title = "^(Kvantum Manager)$" }, float = true })
hl.window_rule({ name = "float-qalculate", match = { class = "^([Qq]alculate-gtk)$" }, float = true })
hl.window_rule({ name = "float-whatsapp", match = { class = "^([Ww]hatsapp-for-linux)$" }, float = true })
hl.window_rule({ name = "float-ferdium", match = { class = "^([Ff]erdium)$" }, float = true })

-- Opacity rules
hl.window_rule({ name = "opacity-rofi", match = { class = "^([Rr]ofi)$" }, opacity = "0.9 0.6" })
hl.window_rule({ name = "opacity-brave", match = { class = "^(Brave-browser(-beta|-dev)?)$" }, opacity = "0.9 0.7" })
hl.window_rule({
    name = "opacity-firefox",
    match = { class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr)$" },
    opacity =
    "0.9 0.7"
})
hl.window_rule({ name = "opacity-thorium", match = { class = "^([Tt]horium-browser)$" }, opacity = "0.9 0.6" })
hl.window_rule({
    name = "opacity-edge",
    match = { class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable)?)$" },
    opacity =
    "0.9 0.8"
})
hl.window_rule({
    name = "opacity-chrome",
    match = { class = "^(google-chrome(-beta|-dev|-unstable)?)$" },
    opacity =
    "0.9 0.8"
})
hl.window_rule({ name = "opacity-chrome-pwa", match = { class = "^(chrome-.+-Default)$" }, opacity = "0.94 0.86" })
hl.window_rule({ name = "opacity-thunar", match = { class = "^([Tt]hunar)$" }, opacity = "0.9 0.8" })
hl.window_rule({ name = "opacity-pcmanfm", match = { class = "pcmanfm-qt" }, opacity = "0.8 0.6" })
hl.window_rule({ name = "opacity-gedit", match = { class = "^(gedit|org.gnome.TextEditor)$" }, opacity = "0.8 0.7" })
hl.window_rule({ name = "opacity-deluge", match = { class = "deluge" }, opacity = "0.9 0.8" })
hl.window_rule({ name = "opacity-alacritty", match = { class = "Alacritty" }, opacity = "0.9 0.8" })
hl.window_rule({ name = "opacity-kitty", match = { class = "kitty" }, opacity = "0.8 0.7" })
hl.window_rule({ name = "opacity-mousepad", match = { class = "mousepad" }, opacity = "0.9 0.7" })
hl.window_rule({ name = "opacity-codium", match = { class = "^(VSCodium|codium-url-handler)$" }, opacity = "0.9 0.7" })
hl.window_rule({ name = "opacity-nwg-qt-opaque", match = { class = "^(nwg-look|qt5ct|qt6ct|yad)$" }, opacity = "0.9 0.8" })
hl.window_rule({ name = "opacity-kvantum-opaque", match = { title = "^(Kvantum Manager)$" }, opacity = "0.9 0.8" })
hl.window_rule({ name = "opacity-obs", match = { class = "com.obsproject.Studio" }, opacity = "0.9 0.7" })
hl.window_rule({ name = "opacity-audacious", match = { class = "^([Aa]udacious)$" }, opacity = "0.9 0.7" })
hl.window_rule({ name = "opacity-nautilus", match = { class = "org.gnome.Nautilus" }, opacity = "0.9 0.8" })
hl.window_rule({ name = "opacity-vscode", match = { class = "^(VSCode|code-url-handler)$" }, opacity = "0.9 0.8" })
hl.window_rule({ name = "opacity-jetbrains", match = { class = "^(jetbrains-.+)$" }, opacity = "0.9 0.8" })
hl.window_rule({ name = "opacity-discord", match = { class = "^([Dd]iscord|[Vv]esktop)$" }, opacity = "0.86 0.70" })
hl.window_rule({
    name = "opacity-telegram",
    match = { class = "^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$" },
    opacity =
    "0.9 0.8"
})
hl.window_rule({
    name = "opacity-gnome-tools",
    match = { class = "^(gnome-disks|evince|wihotspot-gui|org.gnome.baobab)$" },
    opacity =
    "0.94 0.86"
})
hl.window_rule({
    name = "opacity-file-roller-opaque",
    match = { class = "^(file-roller|org.gnome.FileRoller)$" },
    opacity =
    "0.9 0.8"
})
hl.window_rule({ name = "opacity-warp", match = { class = "^(app.drey.Warp)$" }, opacity = "0.8 0.7" })
hl.window_rule({ name = "opacity-seahorse", match = { class = "seahorse" }, opacity = "0.9 0.8" })
hl.window_rule({
    name = "opacity-system-monitor",
    match = { class = "^(gnome-system-monitor|org.gnome.SystemMonitor)$" },
    opacity =
    "0.82 0.75"
})
hl.window_rule({ name = "opacity-xdg-portal", match = { class = "xdg-desktop-portal-gtk" }, opacity = "0.9 0.8" })
hl.window_rule({ name = "opacity-whatsapp-opaque", match = { class = "^([Ww]hatsapp-for-linux)$" }, opacity = "0.9 0.7" })
hl.window_rule({ name = "opacity-ferdium-opaque", match = { class = "^([Ff]erdium)$" }, opacity = "0.9 0.7" })

-- Size rules
hl.window_rule({
    name = "size-system-monitor",
    match = { class = "^(gnome-system-monitor|org.gnome.SystemMonitor)$" },
    size =
    "70% 70%"
})
hl.window_rule({ name = "size-xdg-portal-size", match = { class = "xdg-desktop-portal-gtk" }, size = "70% 70%" })
hl.window_rule({ name = "size-kvantum-size", match = { title = "^(Kvantum Manager)$" }, size = "60% 70%" })
hl.window_rule({ name = "size-qt6ct", match = { class = "qt6ct" }, size = "60% 70%" })
hl.window_rule({ name = "size-evince-wihotspot", match = { class = "^(evince|wihotspot-gui)$" }, size = "70% 70%" })
hl.window_rule({
    name = "size-file-roller-size",
    match = { class = "^(file-roller|org.gnome.FileRoller)$" },
    size =
    "60% 70%"
})
hl.window_rule({ name = "size-whatsapp-size", match = { class = "^([Ww]hatsapp-for-linux)$" }, size = "60% 70%" })
hl.window_rule({ name = "size-ferdium-size", match = { class = "^([Ff]erdium)$" }, size = "60% 70%" })

-- Layer rules for overview blur
hl.layer_rule({ name = "blur-overview", match = { namespace = "^overview$" }, blur = true, ignore_alpha = 0 })

-- Picture-in-Picture rules
hl.window_rule({ name = "pip-opacity", match = { title = "^(Picture-in-Picture)$" }, opacity = "0.95 0.75" })
hl.window_rule({ name = "pip-pin", match = { title = "^(Picture-in-Picture)$" }, pin = true })
hl.window_rule({ name = "pip-float", match = { title = "^(Picture-in-Picture)$" }, float = true })
hl.window_rule({ name = "pip-size", match = { title = "^(Picture-in-Picture)$" }, size = "25% 25%" })
hl.window_rule({ name = "pip-move", match = { title = "^(Picture-in-Picture)$" }, move = "72% 7%" })

-- XWayland video bridge rules
hl.window_rule({ name = "xwayland-opacity", match = { class = "xwaylandvideobridge" }, opacity = "0.0 override" })
hl.window_rule({ name = "xwayland-no-anim", match = { class = "xwaylandvideobridge" }, no_anim = true })
hl.window_rule({ name = "xwayland-no-init-focus", match = { class = "xwaylandvideobridge" }, no_initial_focus = true })
hl.window_rule({ name = "xwayland-max-size", match = { class = "xwaylandvideobridge" }, max_size = "1 1" })
hl.window_rule({ name = "xwayland-no-blur", match = { class = "xwaylandvideobridge" }, no_blur = true })
hl.window_rule({ name = "xwayland-no-focus", match = { class = "xwaylandvideobridge" }, no_focus = true })

-- Gromit-mpx special workspace
hl.workspace_rule({ workspace = "special:gromit", gaps_in = 0, gaps_out = 0, on_created_empty = "gromit-mpx -a" })

-- Gromit-mpx window rules
hl.window_rule({ name = "gromit-float", match = { class = "Gromit-mpx" }, float = true })
hl.window_rule({ name = "gromit-fullscreen", match = { class = "Gromit-mpx" }, fullscreen_state = "2 2" })
hl.window_rule({ name = "gromit-no-blur", match = { class = "Gromit-mpx" }, no_blur = true })
hl.window_rule({ name = "gromit-no-shadow", match = { class = "Gromit-mpx" }, no_shadow = true })
hl.window_rule({ name = "gromit-size", match = { class = "Gromit-mpx" }, size = "100% 100%" })
