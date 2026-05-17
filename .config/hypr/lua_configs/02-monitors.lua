-- Main monitor config
hl.monitor({
    output   = "DP-1",
    mode     = "1920x1080@240",
    position = "0x0",
    scale    = 1,
})

-- Global render settings
hl.config({
    render = {
        direct_scanout = true
    }
})

-- Global misc settings (for this monitor's vrr)
hl.config({
    misc = {
        vrr = 0
    }
})
