-- Animation Settings

-- Define bezier curves using hl.curve
hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1 } } })
hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

hl.animation({ enabled = true, leaf = "windows", speed = 5.7, bezier = "wind", style = "slide" })
hl.animation({ enabled = true, leaf = "windowsIn", speed = 5.7, bezier = "winIn", style = "slide" })
hl.animation({ enabled = true, leaf = "windowsOut", speed = 5.7, bezier = "winOut", style = "slide" })
hl.animation({ enabled = true, leaf = "windowsMove", speed = 5.7, bezier = "wind", style = "slide" })
hl.animation({ enabled = true, leaf = "border", speed = 5.7, bezier = "liner" })
hl.animation({ enabled = true, leaf = "borderangle", speed = 5.7, bezier = "liner", style = "loop" })
hl.animation({ enabled = true, leaf = "fade", speed = 5.7, bezier = "default" })
hl.animation({ enabled = true, leaf = "workspaces", speed = 5.7, bezier = "wind" })
