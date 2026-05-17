-- Workspace Rules

-- XWayland video bridge rules
hl.window_rule({ name = "xwayland-opacity", match = { class = "xwaylandvideobridge" }, opacity = "0.0 override" })
hl.window_rule({ name = "xwayland-no-anim", match = { class = "xwaylandvideobridge" }, no_anim = true })
hl.window_rule({ name = "xwayland-no-init-focus", match = { class = "xwaylandvideobridge" }, no_initial_focus = true })
hl.window_rule({ name = "xwayland-max-size", match = { class = "xwaylandvideobridge" }, max_size = "1 1" })
hl.window_rule({ name = "xwayland-no-blur", match = { class = "xwaylandvideobridge" }, no_blur = true })
hl.window_rule({ name = "xwayland-no-focus", match = { class = "xwaylandvideobridge" }, no_focus = true })

-- Workspace assignments for applications using window_rule with workspace property
hl.window_rule({ name = "workspace-kitty", match = { class = "^([Kk]itty)$" }, workspace = "1" })
hl.window_rule({ name = "workspace-zen", match = { class = "^([Mm]ozilla zen(-alpha|-beta))$" }, workspace = "3" })
hl.window_rule({
    name = "workspace-edge",
    match = { class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable)?)$" },
    workspace =
    "3"
})
hl.window_rule({ name = "workspace-minecraft", match = { class = "^([Mm]inecraft [Ll]auncher)$" }, workspace = "4" })
hl.window_rule({ name = "workspace-steam", match = { class = "^([Ss]team)$" }, workspace = "5" })
hl.window_rule({ name = "workspace-lutris", match = { class = "^([Ll]utris)$" }, workspace = "5" })
hl.window_rule({ name = "workspace-discord", match = { class = "^([Dd]iscord)$" }, workspace = "2" })
hl.window_rule({ name = "workspace-webcord", match = { class = "^([Ww]ebCord)$" }, workspace = "2" })
hl.window_rule({ name = "workspace-vesktop", match = { class = "^([Vv]esktop)$" }, workspace = "2" })
hl.window_rule({ name = "workspace-ferdium", match = { class = "^([Ff]erdium)$" }, workspace = "2" })
hl.window_rule({ name = "workspace-signal", match = { class = "^([Ss]ignal [Dd]esktop)$" }, workspace = "2" })

hl.window_rule({ name = "workspace-virt-manager", match = { class = "^(virt-manager)$" }, workspace = "6 silent" })
hl.window_rule({ name = "workspace-audacious", match = { class = "^([Aa]udacious)$" }, workspace = "9 silent" })
