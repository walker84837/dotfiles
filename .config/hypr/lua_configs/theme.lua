-- Theme Loader - Integrates with wallust-generated colors
-- Parses wallust-hyprland.conf to extract color variables

local M = {}

-- Global colors table accessible to all require'd files
_G.__hyprland_colors = _G.__hyprland_colors or {}

local function home_path()
    return os.getenv("HOME") or "."
end

local function clear_table(t)
    for k in pairs(t) do
        t[k] = nil
    end
end

local function normalize_hex(hex)
    hex = hex:gsub("^#", ""):lower()

    -- Expand shorthand like abc -> aabbcc if it ever appears
    if #hex == 3 then
        hex = hex:gsub(".", "%1%1")
    end

    return hex:sub(1, 6)
end

local function alpha_to_hex(alpha)
    if alpha == nil then
        return "ff"
    end

    if type(alpha) == "number" then
        alpha = math.floor(math.max(0, math.min(255, alpha)))
        return string.format("%02x", alpha)
    end

    alpha = tostring(alpha):lower()

    if alpha:match("^%x%x$") then
        return alpha
    end

    if alpha:match("^0x%x%x$") then
        return alpha:sub(3)
    end

    if alpha:match("^%d+$") then
        local n = tonumber(alpha) or 255
        n = math.floor(math.max(0, math.min(255, n)))
        return string.format("%02x", n)
    end

    error("invalid alpha value: " .. tostring(alpha))
end

function M.load(path)
    local colors = _G.__hyprland_colors
    clear_table(colors)

    local file_path = path or (home_path() .. "/.config/hypr/wallust/wallust-hyprland.conf")
    local file = io.open(file_path, "r")

    if not file then
        print("Warning: Could not load theme file, using fallback colors")

        local fallback = {
            background = "1d1d1f",
            foreground = "fef0c7",
            color0 = "434346",
            color1 = "1a191f",
            color2 = "44332c",
            color3 = "4a3a35",
            color4 = "6e4e39",
            color5 = "74523b",
            color6 = "bd9f47",
            color7 = "f5e1a6",
            color8 = "ac9e75",
            color9 = "232129",
            color10 = "5a443b",
            color11 = "634d46",
            color12 = "92684c",
            color13 = "9a6d4f",
            color14 = "fcd45f",
            color15 = "f5e1a6",
        }

        for k, v in pairs(fallback) do
            colors[k] = v
        end
    else
        for line in file:lines() do
            -- Matches:
            -- $background = rgb(1D1D1F)
            -- $color10 = rgb(5A443B)
            local var, hex = line:match("^%$([%w_]+)%s*=%s*rgb%(([%x]+)%)")
            if var and hex then
                colors[var] = normalize_hex(hex)
            end
        end
        file:close()
    end

    for k, v in pairs(colors) do
        _G[k] = v
    end

    return colors
end

-- Substitute $name in strings with the loaded hex value.
-- Unknown variables are left unchanged.
function M.subst(s)
    if type(s) ~= "string" then
        return s
    end

    return (s:gsub("%$([%w_]+)", function(name)
        return _G.__hyprland_colors[name] or ("%$" .. name)
    end))
end

-- Raw hex, no prefix.
function M.hex(name)
    return _G.__hyprland_colors[name] or "000000"
end

function M.hex_prefixed_alpha(name, alpha)
    return "#" .. (_G.__hyprland_colors[name] or "000000") .. alpha
end

-- Hyprland-friendly rgb() format.
function M.rgb(name)
    return "rgb(" .. M.hex(name) .. ")"
end

-- Hyprland-friendly rgba() format: rgba(rrggbbaa)
function M.rgba(name, alpha)
    return "rgba(" .. M.hex(name) .. alpha_to_hex(alpha) .. ")"
end

-- Packed ARGB format: 0xaarrggbb
function M.argb(name, alpha)
    return "0x" .. alpha_to_hex(alpha) .. M.hex(name)
end

return M
