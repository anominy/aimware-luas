local _g = {}
_g.callbacks = callbacks
_g.draw = draw
_g.gui = gui
_g.client = client
_g.globals = globals
_g.input = input
_g.entities = entities
_g.engine = engine
_g.Vector3 = Vector3

local _util = {}
_util.init_table = function(keys, vals)
    local t = {}
    t.keys = {}
    t.vals = {}

    if (keys == nil or #keys <= 0) then
        return t
    end

    local idx = 1
    for i = 1, #keys do
        local key = keys[i]
        if (key ~= nil) then
            local val = vals ~= nil and vals[i] or nil
            t.keys[idx] = key
            t.vals[idx] = val
            t[key] = val
            idx = idx + 1
        end
    end

    return t
end

_util.in_range = function(n, min, max)
    return (n >= min) and (n <= max)
end

_util.rgb_to_hsb = function(r, g, b, a)
    r = r ~= nil and r / 255 or 0
    g = g ~= nil and g / 255 or 0
    b = b ~= nil and b / 255 or 0
    a = a ~= nil and a / 255 or 0

    r = math.max(0, math.min(1, r))
    g = math.max(0, math.min(1, g))
    b = math.max(0, math.min(1, b))
    a = math.max(0, math.min(1, a))

    local min = math.min(r, g, b)
    local max = math.max(r, g, b)

    local brightness = max
    local saturation = max == 0 and 0 or (max - min) / max

    local hue = 0
    if (max ~= min) then
        if (max == r) then
            hue = (g - b) / (max - min)
        elseif (max == g) then
            hue = 2 + (b - r) / (max - min)
        else
            hue = 4 + (r - g) / (max - min)
        end
    end
    hue = hue / 6

    if (hue < 0) then
        hue = hue + 1
    elseif (hue > 1) then
        hue = hue - 1
    end

    return hue, saturation, brightness, a
end

_util.hsb_to_rgb = function(h, s, b, a)
    h = h ~= nil and h or 0
    s = s ~= nil and s or 0
    b = b ~= nil and b or 0
    a = a ~= nil and a or 1

    h = math.max(0, math.min(1, h))
    s = math.max(0, math.min(1, s))
    b = math.max(0, math.min(1, b))
    a = math.max(0, math.min(1, a))

    local hue = h * 360

    if (s == 0) then
        local v = math.floor(b * 255 + 0.5)
        return v, v, v, math.floor(a * 255 + 0.5)
    end

    local sector = math.floor(hue / 60)
    local fraction = (hue / 60) - sector

    local p = b * (1 - s)
    local q = b * (1 - s * fraction)
    local t = b * (1 - s * (1 - fraction))

    local red, green, blue
    if (sector == 0) then
        red, green, blue = b, t, p
    elseif (sector == 1) then
        red, green, blue = q, b, p
    elseif (sector == 2) then
        red, green, blue = p, b, t
    elseif (sector == 3) then
        red, green, blue = p, q, b
    elseif (sector == 4) then
        red, green, blue = t, p, b
    else
        red, green, blue = b, p, q
    end

    return math.floor(red * 255 + 0.5), math.floor(green * 255 + 0.5), math.floor(blue * 255 + 0.5), math.floor(a * 255 + 0.5)
end

_util.interp_color2 = function(color1, color2, factor)
    factor = math.max(0, math.min(1, factor))

    local r = math.floor(color1[1] + (color2[1] - color1[1]) * factor + 0.5);
    local g = math.floor(color1[2] + (color2[2] - color1[2]) * factor + 0.5);
    local b = math.floor(color1[3] + (color2[3] - color1[3]) * factor + 0.5);
    local a = math.floor(color1[4] + (color2[4] - color1[4]) * factor + 0.5);

    return math.max(0, math.min(255, r)), math.max(0, math.min(255, g)), math.max(0, math.min(255, b)), math.max(0, math.min(255, a))
end

_util.interp_color3 = function(color1, color2, color3, factor)
    factor = math.max(0, math.min(1, factor))

    if (factor <= 0.5) then
        local f = factor / 0.5
        return math.floor(color1[1] + (color2[1] - color1[1]) * f + 0.5), math.floor(color1[2] + (color2[2] - color1[2]) * f + 0.5), math.floor(color1[3] + (color2[3] - color1[3]) * f + 0.5), math.floor(color1[4] + (color2[4] - color1[4]) * f + 0.5)
    end

    local f = (factor - 0.5) / 0.5
    return math.floor(color2[1] + (color3[1] - color2[1]) * f + 0.5), math.floor(color2[2] + (color3[2] - color2[2]) * f + 0.5), math.floor(color2[3] + (color3[3] - color2[3]) * f + 0.5), math.floor(color2[4] + (color3[4] - color2[4]) * f + 0.5)
end

_util.hnext = function(ht, hty, idx, g, limit)
    if (ht == nil) then
        return
    end

    hty = tostring(hty)
    idx = tostring(idx)

    if (ht[hty] == nil) then
        ht[hty] = {}
    end
    if (ht[hty][idx] == nil) then
        ht[hty][idx] = {}
    end

    local val = ht[hty][idx][1]
    if (val == nil) then
        val = 0
    end

    val = g(val)

    table.insert(ht[hty][idx], 1, val)
    if (#ht[hty][idx] > limit) then
        table.remove(ht[hty][idx])
    end
end

_util.hpred = function(p)
    return function(val)
        local r = p()
        if (r == nil) then
            return nil
        else
            if (r) then
                if (val < 0) then
                    val = 0
                end
                return val + 1
            else
                if (val > 0) then
                    val = 0
                end
                return val - 1
            end
        end
    end
end

_util.hsupp = function(p)
    return function(ignored)
        return p()
    end
end

_util.hget = function(ht, hty, idx, n)
    if (ht == nil) then
        return n == nil and {} or nil
    end

    hty = tostring(hty)
    idx = tostring(idx)

    if (ht[hty] == nil) then
        return n == nil and {} or nil
    end
    if (ht[hty][idx] == nil) then
        return n == nil and {} or nil
    end

    return n == nil and ht[hty][idx] or ht[hty][idx][n]
end

_util.fnext = function(ft, fn, fs, fw)
    if (ft == nil) then
        return nil
    end

    fn = tostring(fn)
    fs = tostring(fs)
    fw = tostring(fw)

    if (ft[fn] == nil) then
        ft[fn] = {}
    end
    if (ft[fn][fs] == nil) then
        ft[fn][fs] = {}
    end
    if (ft[fn][fs][fw] == nil) then
        ft[fn][fs][fw] = _g.draw.CreateFont(fn, tonumber(fs), tonumber(fw))
    end
    return ft[fn][fs][fw]
end

_util.nangle = function(a)
    if (a == nil) then
        return nil
    end
    local result = tonumber(a)
    while (result <= 180) do
        result = result + 360
    end
    while (result > 180) do
        result = result - 360
    end
    return result
end

-- _util.pangle = function(wish, speed)
--     return math.atan(wish / speed) * (180 / math.pi)
-- end

_util.lerp = function(a, b, t)
    if (a == nil or b == nil or t == nil) then
        return nil
    end
    a = tonumber(a)
    b = tonumber(b)
    t = tonumber(t)
    return a + (b - a) * t
end

_util.vlen3 = function(x, y, z)
    x = tonumber(x)
    y = tonumber(y)
    z = tonumber(z)
    return math.sqrt(x^2 + y^2 + z^2)
end

_util.vlen2 = function(x, y)
    return _util.vlen3(x, y, 0)
end

local _default = {}
_default.tlen = 2^10

_default.vel_far_color = {255, 0, 255, 255}
_default.vel_pos_color = {0, 255, 0, 255}
_default.vel_neu_color = {255, 255, 0, 255}
_default.vel_neg_color = {255, 0, 0, 255}
_default.vel_shd_color = {0, 0, 0, 255}

_default.interp_start_color = {255, 0, 0, 255}
_default.interp_middle_color = {255, 255, 0, 255}
_default.interp_end_color = {0, 255, 0, 255}

_default.shadow_color = {0, 0, 0, 255}

_default.fw_alias = "-forward"
_default.bw_alias = "-back"
_default.rt_alias = "-moveright"
_default.lt_alias = "-moveleft"

_default.laj_fw_alias = _default.fw_alias
_default.laj_bw_alias = _default.bw_alias

_default.ej_fw_alias = _default.fw_alias
_default.ej_bw_alias = _default.bw_alias
_default.ej_rt_alias = _default.rt_alias
_default.ej_lt_alias = _default.lt_alias

_default.lj_fw_alias = _default.fw_alias
_default.lj_bw_alias = _default.bw_alias
_default.lj_rt_alias = _default.rt_alias
_default.lj_lt_alias = _default.lt_alias

_default.weapon_speed = {
    [42]    = 250,      -- Knife (CT)
    [59]    = 250,      -- Knife (T)
    [517]   = 250,      -- Paracord Knife
    [518]   = 250,      -- Survival Knife
    [521]   = 250,      -- Nomad Knife
    [525]   = 250,      -- Skeleton Knife
    [503]   = 250,      -- Classic Knife
    [519]   = 250,      -- Ursus
    [520]   = 250,      -- Navaja
    [522]   = 250,      -- Stiletto
    [523]   = 250,      -- Talon
    [507]   = 250,      -- Karambit
    [508]   = 250,      -- M9 Bayonet
    [500]   = 250,      -- Bayonet
    [514]   = 250,      -- Bowie Knife
    [515]   = 250,      -- Butterfly Knife
    [505]   = 250,      -- Flip Knife
    [516]   = 250,      -- Shadow Daggers
    [509]   = 250,      -- HUntsman Knife
    [512]   = 250,      -- Falshion Knife
    [506]   = 250,      -- Gut Knife
    [32]    = 240,      -- P2000
    [2]     = 240,      -- Dual Berretas
    [36]    = 240,      -- P250
    [3]     = 240,      -- Five-Seven
    [1]     = 230,      -- Desert Eadgle
    [16]    = 225,      -- M4A4
    [40]    = 230,      -- SSG 08
    [8]     = 220,      -- AUG
    [9]     = 200,      -- AWP
    [38]    = 215,      -- SCAR-20
    [10]    = 220,      -- FAMAS
    [31]    = 220,      -- Zeus x27
    [48]    = 245,      -- Incendiary Grenade
    [47]    = 245,      -- Decoy Grenade
    [43]    = 245,      -- Flashbang
    [45]    = 245,      -- Smoke Grenade
    [44]    = 245,      -- High Explosive Grenade
    [34]    = 240,      -- MP9
    [33]    = 220,      -- MP7
    [24]    = 230,      -- UMP-45
    [19]    = 230,      -- P90
    [26]    = 240,      -- PP-Bizon
    [35]    = 220,      -- Nova
    [25]    = 215,      -- XM1014
    [27]    = 225,      -- MAG-7
    [28]    = 150,      -- Negev
    [14]    = 195,      -- M249
    [4]     = 240,      -- Glock-18
    [30]    = 240,      -- Tec-9
    [29]    = 210,      -- Sawed-Off
    [17]    = 240,      -- MAC-10
    [7]     = 215,      -- AK-47
    [13]    = 215,      -- Galil AR
    [39]    = 210,      -- SG 553
    [11]    = 215,      -- G3SG1
    [46]    = 245       -- Molotov
}

_default.wpn_sway = 1.6
_default.debug_spread = 0

_default.hlimit = 3

local _class = {}
_class.player = "CCSPlayer"

local _prop = {}
_prop.obs_target = "m_hObserverTarget"
_prop.obs_mode = "m_iObserverMode"
_prop.flags = "m_fFlags"
_prop.render_mode = "m_nRenderMode"
_prop.vel_x = "m_vecVelocity[0]"
_prop.vel_y = "m_vecVelocity[1]"
_prop.vel_z = "m_vecVelocity[2]"
_prop.scope = "m_bIsScoped"
_prop.stamina = "m_flStamina"

local _con = {}
_con.debug_spread = "weapon_debug_spread_show"
_con.crosshair_style = "cl_crosshairstyle"
_con.wpn_sway = "cl_wpn_sway_scale"
_con.wish_speed = "sv_air_max_wishspeed"
_con.air_acc = "sv_airaccelerate"
_con.gravity = "sv_gravity"

local _var = {}
_var.jb = "misc.autojumpbug"
_var.ej = "misc.edgejump"

local _render = {}
_render.ladder = 2304

local _flag = {}
_flag.on_ground = 1
_flag.ducking = 2
_flag.water_jump = 8
_flag.in_water = 1024
_flag.swim = 4096

local _button = {}
_button.in_jump = 2
_button.in_duck = 4
_button.in_speed = 131072

local _jt = {}
_jt.none = 0
_jt.jump = 1
_jt.perfect = 2
_jt.jb = 3
_jt.laj = 4
_jt.lag = 5
_jt.lah = 6
_jt.ps = 7
_jt.eb = 8
_jt.hh = 9

_jt.names = {
    [_jt.none] = "None",
    [_jt.jump] = "Jump",
    [_jt.perfect] = "Perfect",
    [_jt.jb] = "Jump-Bug",
    [_jt.laj] = "Ladder Jump",
    [_jt.lag] = "Ladder Glide",
    [_jt.lah] = "Ladder Hop",
    [_jt.ps] = "Pixel Surf",
    [_jt.eb] = "Edge-Bug",
    [_jt.hh] = "Head Hit"
}

local _ht = {}
_ht.utrace = 1
_ht.flags = 2
_ht.ground = 3
_ht.duck = 4
_ht.vel = 5
_ht.tvel = 6
_ht.scope = 7
_ht.ladder = 8
_ht.lag = 9
_ht.ps = 10
_ht.jt = 11
_ht.moves = 12
_ht.specs = 13
_ht.angles = 14
_ht.dangles = 15
_ht.pangle = 16
_ht.pre_flags = 17
_ht.pre_duck = 18

local _jbt = {}
_jbt.standard = 1
_jbt.improved = 2

local _client = {}
_client.lcl = nil
_client.plr = nil
_client.trg = nil

local _screen = {}
_screen.width = nil
_screen.height = nil

local _history = {}
local _font = {}

local _ref = {}
_ref.menu = _g.gui.Reference("Menu")
_ref.settings = _g.gui.Reference("Settings")

local _tab = {}
_tab.movement = _g.gui.Tab(_ref.settings, "settings.movement", "Movement")

local _ui = {}
_ui.font = _util.init_table({"Consolas", "AcPlus IBM BIOS"}, {})
_ui.jbt = _util.init_table({"Standard", "Improved"}, {_jbt.standard, _jbt.improved})
-- _ui.case = _util.init_table({"Lower", "Upper"}, {string.lower, string.upper})
-- _ui.format = _util.init_table({"Medium", "Short", "Long"}, {"u/s", "u", "units/seconds"})
-- _ui.separator = _util.init_table({"Space", "None", "Dash", "Colon", "Line", "Slash", "Back Slash"}, {" ", "", "-", ":", "|", "/", "\\"})
-- _ui.bracket = _util.init_table({"None", "Round", "Square", "Curly", "Angle"}, {{"", ""}, {"(", ")"}, {"[", "]"}, {"{", "}"}, {"<", ">"}})

_ui.debug_checkbox = _g.gui.Checkbox(_tab.movement, "debug.checkbox", "Debug", false)
_ui.debug_checkbox:SetDescription("Show a debug text on the left top corner of the screen.")

_ui.debug_specs_checkbox = _g.gui.Checkbox(_tab.movement, "debug.specs.checkbox", "Debug Spectators", false)
_ui.debug_specs_checkbox:SetDescription("Show a debug text on the left top corner of the screen with a list of spectators.")

_ui.debug_jt_checkbox = _g.gui.Checkbox(_tab.movement, "debug.jt.checkbox", "Debug Jump Type", false)
_ui.debug_jt_checkbox:SetDescription("Show a debug text on the right top corner of the screen with a current jump type.")

-- _ui.debug_pangle_checkbox = _g.gui.Checkbox(_tab.movement, "debug.pangle.checkbox", "Debug Perfect Angle", false)
-- _ui.debug_pangle_checkbox:SetDescription("Show a debug text near the debug speed value with current perfect angle ratio.")

_ui.spread_checkbox = _g.gui.Checkbox(_tab.movement, "spread.checkbox", "Spread", false)
_ui.spread_checkbox:SetDescription("Show weapon spread using the `weapon_debug_spread_show` console variable.")

_ui.spread_hide_checkbox = _g.gui.Checkbox(_tab.movement, "spread.hide.checkbox", "Spread Hide", false)
_ui.spread_hide_checkbox:SetDescription("Hide weapon spread while scroping using the `weapon_debug_spread_show` console variable.")

_ui.spread_start_slider = _g.gui.Slider(_tab.movement, "spread.start.slider", "Spread Start", 0.01, 0, 1, 0.005)
_ui.spread_start_slider:SetDescription("Innacuracy value of current weapon from which to start showing the weapon spread.")

_ui.wpn_sway_checkbox = _g.gui.Checkbox(_tab.movement, "wpn.sway.checkbox", "Weapon Sway", false)
_ui.wpn_sway_checkbox:SetDescription("Override the `cl_wpn_sway_scale` console variable.")

_ui.wpn_sway_scale_slider = _g.gui.Slider(_tab.movement, "wpn.sway.scale.slider", "Weapon Sway Scale", 0, 0, 1.6, 0.01)
_ui.wpn_sway_scale_slider:SetDescription("Set value of the `cl_wpn_sway_scale` console variable.")

_ui.jb_checkbox = _g.gui.Checkbox(_tab.movement, "jb.checkbox", "Jump-Bug", false)
_ui.jb_checkbox:SetDescription("Disable the auto jump-bug on the ground and enable it in the air.")

_ui.jb_auto_jump_checkbox = _g.gui.Checkbox(_tab.movement, "jb.auto_jump.checkbox", "Jump-Bug Auto Jump", true)
_ui.jb_auto_jump_checkbox:SetDescription("Switch the jump-bug's auto jump, if disabled, it will supress the auto jump after a failed jump-bug.")

_ui.jb_type_combobox = _g.gui.Combobox(_tab.movement, "jb.type.combobox", "Jump-Bug Type", unpack(_ui.jbt.keys))
_ui.jb_type_combobox:SetDescription("Switch an implementation of the auto jump-bug feature.")

_ui.jb_lag_checkbox = _g.gui.Checkbox(_tab.movement, "jb.lag.checkbox", "Jump-Bug Ladder Glide", true)
_ui.jb_lag_checkbox:SetDescription("Set in-jump button when holding the jump-bug key while ladder moving.")

_ui.laj_checkbox = _g.gui.Checkbox(_tab.movement, "laj.checkbox", "Ladder Jump", false)
_ui.laj_checkbox:SetDescription("Release +forward or +back at start of a ladder jump.")

_ui.laj_ground_checkbox = _g.gui.Checkbox(_tab.movement, "laj.ground.checkbox", "Ladder Jump On Ground", false)
_ui.laj_ground_checkbox:SetDescription("Release +forward or +back at start of a ladder walk-off.")

_ui.laj_alias_fw_editbox = _g.gui.Editbox(_tab.movement, "laj.alias.fw.editbox", "Ladder Jump Custom Forward Alias")
_ui.laj_alias_fw_editbox:SetDescription("Set custom forawrd alias that will be executed at start of a ladder jump.")

_ui.laj_alias_bw_editbox = _g.gui.Editbox(_tab.movement, "laj.alias.bw.editbox", "Ladder Jump Custom Back Alias")
_ui.laj_alias_bw_editbox:SetDescription("Set custom back alias that will be executed at statrt of a ladder jump.")

_ui.ej_checkbox = _g.gui.Checkbox(_tab.movement, "ej.checkbox", "Edge Jump", false)
_ui.ej_checkbox:SetDescription("Release +forward or +back or +moveright or +moveleft at start of an edge jump.")

_ui.ej_alias_fw_editbox = _g.gui.Editbox(_tab.movement, "ej.alias.fw.editbox", "Edge Jump Custom Forward Alias")
_ui.ej_alias_fw_editbox:SetDescription("Set custom forawrd alias that will be executed at start of an edge jump.")

_ui.ej_alias_bw_editbox = _g.gui.Editbox(_tab.movement, "ej.alias.bw.editbox", "Edge Jump Custom Back Alias")
_ui.ej_alias_bw_editbox:SetDescription("Set custom back alias that will be executed at start of an edge jump.")

_ui.ej_alias_rt_editbox = _g.gui.Editbox(_tab.movement, "ej.alias.rt.editbox", "Edge Jump Custom Right Alias")
_ui.ej_alias_rt_editbox:SetDescription("Set custom right alias that will be executed at start of an edge jump.")

_ui.ej_alias_lt_editbox = _g.gui.Editbox(_tab.movement, "ej.alias.lt.editbox", "Edge Jump Custom Left Alias")
_ui.ej_alias_lt_editbox:SetDescription("Set custom left alias that will be executed at start of an edge jump.")

_ui.lj_checkbox = _g.gui.Checkbox(_tab.movement, "lj.checkbox", "Long Jump", false)
_ui.lj_checkbox:SetDescription("Release +forward or +back or +moveright or +moveleft at start of a long jump.")

_ui.lj_ticks_slider = _g.gui.Slider(_tab.movement, "lj.ticks.slider", "Long Jump Ticks", 2, 2, 64)
_ui.lj_ticks_slider:SetDescription("Set how many ticks on the ground needed before doing a long jump.")

_ui.lj_scroll_checkbox = _g.gui.Checkbox(_tab.movement, "lj.scroll.checkbox", "Long Jump Scroll", false)
_ui.lj_scroll_checkbox:SetDescription("Release +forawrd or +back or +moveright or +moveleft at start of a scroll long jump.")

_ui.lj_scroll_ticks_slider = _g.gui.Slider(_tab.movement, "lj.scroll.ticks.slider", "Long Jump Scroll TIcks", 8, 2, 64)
_ui.lj_scroll_ticks_slider:SetDescription("Set how many ticks on the ground needed before doing a scroll jump.")

_ui.lj_alias_fw_editbox = _g.gui.Editbox(_tab.movement, "lj_alias.fw.editbox", "Long Jump Custom Forward Alias")
_ui.lj_alias_fw_editbox:SetDescription("Set custom forward alias that will be executed at start of a long jump.")

_ui.lj_alias_bw_editbox = _g.gui.Editbox(_tab.movement, "lj.alias.bw.editbox", "Long Jump Custom Back Alias")
_ui.lj_alias_bw_editbox:SetDescription("Set custom back alias that will be executed at start of a long jump.")

_ui.lj_alias_rt_editbox = _g.gui.Editbox(_tab.movement, "lj.alias.rt.editbox", "Long Jump Custom Right Alias")
_ui.lj_alias_rt_editbox:SetDescription("Set custom right alias that will be executed at start of a long jump.")

_ui.lj_alias_lt_editbox = _g.gui.Editbox(_tab.movement, "lj.alias.lt.editbox", "Long Jump Custom Left Alias")
_ui.lj_alias_lt_editbox:SetDescription("Set custom left alias that will be executed at start of a long jump.")

_ui.global_font_name_combobox = _g.gui.Combobox(_tab.movement, "global.font.name", "Global Font Name", unpack(_ui.font.keys))
_ui.global_font_name_combobox:SetDescription("Set the global font name used to render any text.")

_ui.global_font_size_slider = _g.gui.Slider(_tab.movement, "global.font.size", "Global Font Size", 20, 1, 64)
_ui.global_font_size_slider:SetDescription("Set the global font size used to render any text.")

_ui.global_font_weight_slider = _g.gui.Slider(_tab.movement, "global.font.weight", "Global Font Weight", 900, 100, 900, 100)
_ui.global_font_weight_slider:SetDescription("Set the global font weight used to render any text.")

_ui.global_shadow_checkbox = _g.gui.Checkbox(_tab.movement, "global.shadow.checkbox", "Global Shadow", true)
_ui.global_shadow_checkbox:SetDescription("Render shadows of all elements that are supported.")

_ui.global_shadow_offset_x_slider = _g.gui.Slider(_tab.movement, "global.shadow.offset.x.slider", "GLobal Shadow X-Axis", 1, -2, 2)
_ui.global_shadow_offset_x_slider:SetDescription("Set the global shadow offset on the x-axis.")

_ui.global_shadow_offset_y_slider = _g.gui.Slider(_tab.movement, "global.shadow.offset.y.slider", "Global Shadow Y-Axis", 1, -2, 2)
_ui.global_shadow_offset_y_slider:SetDescription("Set the global shadow offset on the y-axis.")

_ui.global_shadow_color = _g.gui.ColorPicker(_tab.movement, "global.shadow.color", "Global Shadow Color", unpack(_default.shadow_color))

_ui.global_shadow_saturation_slider = _g.gui.Slider(_tab.movement, "global.shadow.saturation.slider", "Global Shadow Saturation", 1, 0, 1, 0.01)
_ui.global_shadow_saturation_slider:SetDescription("Set the global shadow color saturation.")

_ui.global_shadow_brightness_slider = _g.gui.Slider(_tab.movement, "global.shadow.brightness.slider", "Global Shadow Brightness", 1, 0, 1, 0.01)
_ui.global_shadow_brightness_slider:SetDescription("Set the global shadow color brightness.")

_ui.global_rbow_checkbox = _g.gui.Checkbox(_tab.movement, "global.rainbow.checkbox", "Global Rainbow", false)
_ui.global_rbow_checkbox:SetDescription("Use rainbow as a color for all elements that are supported.")

_ui.global_rbow_cycle_slider = _g.gui.Slider(_tab.movement, "global.rainbow.cycle.slider", "Global Rainbow Cycle", 8, 0.01, 60, 0.01)
_ui.global_rbow_cycle_slider:SetDescription("Set the global rainbow color cycle time.")

_ui.global_rbow_shift_slider = _g.gui.Slider(_tab.movement, "global.rainbow.shift.slider", "Global Rainbow Shift", 0, 0, 1, 0.01)
_ui.global_rbow_shift_slider:SetDescription("Set the global rainbow color hue shift.")

_ui.global_rbow_saturation_slider = _g.gui.Slider(_tab.movement, "global.rainbow.saturation.slider", "Global Rainbow Saturation", 1, 0, 1, 0.01)
_ui.global_rbow_saturation_slider:SetDescription("Set the global rainbow color saturation.")

_ui.global_rbow_brightness_slider = _g.gui.Slider(_tab.movement, "global.rainbow.brightness.slider", "Global Rainbow Brightness", 1, 0, 1, 0.01)
_ui.global_rbow_brightness_slider:SetDescription("Set the global rainbow color brightness.")

_ui.speed_checkbox = _g.gui.Checkbox(_tab.movement, "speed.checkbox", "Speed", false)
_ui.speed_checkbox:SetDescription("Show player's speed on the screen.")

_ui.speed_hide_checkbox = _g.gui.Checkbox(_tab.movement, "speed.hide.chekbox", "Speed Hide", false)
_ui.speed_hide_checkbox:SetDescription("Hide player's speed while scoping.")

_ui.speed_ladder_checkbox = _g.gui.Checkbox(_tab.movement, "speed.ladder.checkbox", "Speed Ladder", false)
_ui.speed_ladder_checkbox:SetDescription("Show player's vertical speed while ladder moving.")

_ui.speed_font_checkbox = _g.gui.Checkbox(_tab.movement, "speed.font.checkbox", "Speed Font", false)
_ui.speed_font_checkbox:SetDescription("Override the global font parameters.")

_ui.speed_font_name_combobox = _g.gui.Combobox(_tab.movement, "speed.font.name.combobox", "Speed Font Name", unpack(_ui.font.keys))
_ui.speed_font_name_combobox:SetDescription("Set player's speed font name used to render the value text.")

_ui.speed_font_size_slider = _g.gui.Slider(_tab.movement, "speed.font.size.slider", "Speed Font Size", 20, 1, 64)
_ui.speed_font_size_slider:SetDescription("Set player's speed font size used to render the value text.")

_ui.speed_font_weight_slider = _g.gui.Slider(_tab.movement, "speed.font.weight.slider", "Speed Font Weight", 900, 100, 900, 100)
_ui.speed_font_weight_slider:SetDescription("Set player's speed font weight used to render the value text.")

_ui.speed_shadow_checkbox = _g.gui.Checkbox(_tab.movement, "speed.shadow.checkbox", "Speed Shadow", false)
_ui.speed_shadow_checkbox:SetDescription("Override the global shadow parameters.")

_ui.speed_shadow_offset_x_slider = _g.gui.Slider(_tab.movement, "speed.shadow.offset.x.slider", "Speed Shadow X-Axis", 1, -2, 2)
_ui.speed_shadow_offset_x_slider:SetDescription("Set player's speed shadow offset on the x-axis.")

_ui.speed_shadow_offset_y_slider = _g.gui.Slider(_tab.movement, "speed.shadow.offset.y.slider", "Speed Shadow Y-Axis", 1, -2, 2)
_ui.speed_shadow_offset_y_slider:SetDescription("Set player's speed shadow offset on the y-axis.")

_ui.speed_shadow_color =_g.gui.ColorPicker(_tab.movement, "speed.shadow.color", "Speed Shadow Color", unpack(_default.vel_shd_color))

_ui.speed_shadow_saturation_slider = _g.gui.Slider(_tab.movement, "speed.shadow.saturation.slider", "Speed Shadow Saturation", 1, 0, 1, 0.01)
_ui.speed_shadow_saturation_slider:SetDescription("Set player's speed shadow color saturation.")

_ui.speed_shadow_brightness_slider = _g.gui.Slider(_tab.movement, "speed.shadow.brightness.slider", "Speed Shadow Brightness", 1, 0, 1, 0.01)
_ui.speed_shadow_brightness_slider:SetDescription("Set player's speed shadow color brightness.")

_ui.speed_rbow_checkbox = _g.gui.Checkbox(_tab.movement, "speed.rainbow.checkbox", "Speed Rainbow", false)
_ui.speed_rbow_checkbox:SetDescription("Override the global rainbow parameters.")

_ui.speed_rbow_cycle_slider = _g.gui.Slider(_tab.movement, "speed.rainbow.cycle.slider", "Speed Rainbow Cycle", 8, 0.01, 60, 0.01)
_ui.speed_rbow_cycle_slider:SetDescription("Set player's speed rainbow color cycle time.")

_ui.speed_rbow_shift_slider = _g.gui.Slider(_tab.movement, "speed.rainbow.shift.slider", "Speed Rainbow Shift", 0, 0, 1, 0.01)
_ui.speed_rbow_shift_slider:SetDescription("Set player's speed rainbow color hue shift.")

_ui.speed_rbow_saturation_slider = _g.gui.Slider(_tab.movement, "speed.rainbow.saturation.slider", "Speed Rainbow Saturation", 1, 0, 1, 0.01)
_ui.speed_rbow_saturation_slider:SetDescription("Set player's speed rainbow color saturataion.")

_ui.speed_rbow_brightness_slider = _g.gui.Slider(_tab.movement, "speed.rainbow.birghtness.slider", "Speed Rainbow Birghtness", 1, 0, 1, 0.01)
_ui.speed_rbow_brightness_slider:SetDescription("Set player's speed rainbow color brightness.")

_ui.speed_x_checkbox = _g.gui.Checkbox(_tab.movement, "speed.x.checkbox", "Speed by X-Axis", true)
_ui.speed_x_checkbox:SetDescription("Use player's x-axis speed for accumulating.")

_ui.speed_y_checkbox = _g.gui.Checkbox(_tab.movement, "speed.y.checkbox", "Speed by Y-Axis", true)
_ui.speed_y_checkbox:SetDescription("Use player's y-axis speed for accumulating.")

_ui.speed_z_checkbox = _g.gui.Checkbox(_tab.movement, "speed.z.checkbox", "Speed by Z-Axis", false)
_ui.speed_z_checkbox:SetDescription("Use player's z-axis speed for accumulating.")

_ui.speed_pos_x_slider = _g.gui.Slider(_tab.movement, "speed.position.x.slider", "Speed X-Axis Position", 0.5, 0, 1, 0.01)
_ui.speed_pos_x_slider:SetDescription("Set player's speed position on the x-axis of the screen.")

_ui.speed_pos_y_slider = _g.gui.Slider(_tab.movement, "speed.position.y.slider", "Speed Y-Axis Position", 0.4, 0, 1, 0.01)
_ui.speed_pos_y_slider:SetDescription("Set player's speed position on the y-axis of the screen.")

_ui.speed_accuracy_slider = _g.gui.Slider(_tab.movement, "speed.accuracy.slider", "Speed Accuracy", 0, 0, 3)
_ui.speed_accuracy_slider:SetDescription("Set player's speed accuracy which represents the number of digits after the value dot.")

_ui.speed_zeros_slider = _g.gui.Slider(_tab.movement, "speed.zeros.slider", "Speed Zeros", 0, 0, 3)
_ui.speed_zeros_slider:SetDescription("Set player's speed zeros which represents the number of leading zeros of the value.")

_ui.speed_far_color = _g.gui.ColorPicker(_tab.movement, "speed.far.color", "Speed Far Color", unpack(_default.vel_far_color))

_ui.speed_far_slider = _g.gui.Slider(_tab.movement, "speed.far.slider", "Speed Far Value", 340, 286, 480)
_ui.speed_far_slider:SetDescription("Set player's speed limit for a far value.")

_ui.speed_far_ladder_slider = _g.gui.Slider(_tab.movement, "speed.far.ladder.slider", "Speed Far Ladder Value", 310, 104, 312)
_ui.speed_far_ladder_slider:SetDescription("Set player's speed limit for a far value while ladder moving.")

_ui.speed_positive_color = _g.gui.ColorPicker(_tab.movement, "speed.positive.color", "Speed Positive Color", unpack(_default.vel_pos_color))
_ui.speed_neutral_color = _g.gui.ColorPicker(_tab.movement, "speed.neutral.color", "Speed Neutral Color", unpack(_default.vel_neu_color))
_ui.speed_negative_color = _g.gui.ColorPicker(_tab.movement, "speed.negative.color", "Speed Negative Color", unpack(_default.vel_neg_color))

_ui.speed_neutral_color_disable_in_air_checkbox = _g.gui.Checkbox(_tab.movement, "speed.neutral.color.disable_in_air.checkbox", "Disable Speed Neutral Color In Air", true)
_ui.speed_neutral_color_disable_in_air_checkbox:SetDescription("Disable render of neutral color while moving in the air.")

_ui.speed_negative_color_disable_on_ground_checkbox = _g.gui.Checkbox(_tab.movement, "speed.negative.color.disable_on_ground.checkbox", "Disable Speed Negative Color On Ground", true)
_ui.speed_negative_color_disable_on_ground_checkbox:SetDescription("Disable render of negative color whle moving on the ground.")

_ui.speed_neutral_color_ticks_slider = _g.gui.Slider(_tab.movement, "speed.neutral.color.ticks.slider", "Speed Neutral Color Ticks", 1, 0, 2)
_ui.speed_neutral_color_ticks_slider:SetDescription("Set delay in ticks for neutral color change of player's speed.")

_ui.speed_negative_color_ticks_slider = _g.gui.Slider(_tab.movement, "speed.negative.color.ticks.slider", "Speed Negative Color Ticks", 1, 0, 2)
_ui.speed_negative_color_ticks_slider:SetDescription("Set delay in ticks for negative color change of player's speed.")

_ui.speed_neutral_color_delta_error_slider = _g.gui.Slider(_tab.movement, "speed.neutral.color.delta_error.slider", "Speed Neutral Color Delta Error", 0.5, 0, 1, 0.01)
_ui.speed_neutral_color_delta_error_slider:SetDescription("Set player's speed delta error for neutral color.")

_ui.speed_negative_color_delta_error_slider = _g.gui.Slider(_tab.movement, "speed.negative.color.delta_error.slider", "Speed Negative Color Delta Error", 0.5, 0, 1, 0.01)
_ui.speed_negative_color_delta_error_slider:SetDescription("Set player's speed delta error for negative color.")

local _context = {}
_context.jb_button = 0
_context.speed_font = nil
_context.speed_shadow_offset_x = nil
_context.speed_shadow_offset_y = nil
_context.speed_shadow_color = nil
_context.speed_color = nil
_context.strafe_eff = nil

local _callback = {}
_callback.move = "CreateMove"
_callback.pre_move = "PreMove"
_callback.post_move = "PostMove"
_callback.draw = "Draw"

local _call = {}
_call.move = {
    function(cmd)
        _client.lcl = _g.entities.GetLocalPlayer()
        if (_client.lcl) then
            if (_client.lcl:IsAlive()) then
                _client.plr = _client.lcl
                _client.trg = nil
            else
                _client.trg = _client.lcl:GetPropEntity(_prop.obs_target)
                _client.plr = _client.trg
            end
        else
            _client.plr = nil
            _client.trg = nil
        end
    end,

    function(cmd)
        local entlist = _g.entities.FindByClass(_class.player)

        if (_client.lcl) then
            local entity = _client.lcl
            local index = entity:GetIndex()
            _util.hnext(_history, _ht.moves, index, _util.hsupp(function()
                return {cmd.forwardmove, cmd.sidemove}
            end), _default.hlimit)
        end

        if (_client.lcl) then
            local entity = _client.lcl
            local index = entity:GetIndex()
            _util.hnext(_history, _ht.utrace, index, _util.hsupp(function()
                local is_alive = entity:IsAlive()
                if (not is_alive) then
                    return nil
                end
                local origin = entity:GetAbsOrigin()
                if (origin == nil) then
                    return nil
                end
                local mins = entity:GetMins()
                if (mins == nil) then
                    return nil
                end
                local maxs = entity:GetMaxs()
                if (maxs == nil) then
                    return nil
                end
                local source = _g.Vector3(origin.x, origin.y, origin.z + maxs.z)
                local destination = _g.Vector3(source.x, source.y, source.z + _default.tlen)
                maxs.z = 0
                local trace = _g.engine.TraceHull(source, destination, mins, maxs)
                if (trace.fraction == 1) then
                    return nil
                end
                return trace
            end), _default.hlimit)
        end

        if (_client.lcl and _client.plr) then
            local entity = _client.plr
            local index = entity:GetIndex()
            _util.hnext(_history, _ht.angles, index, _util.hsupp(function()
                local is_alive = entity:IsAlive()
                if (not is_alive) then
                    return {nil, nil, nil}
                end
                local obs_mode = _client.lcl:GetPropInt(_prop.obs_mode)
                if (obs_mode == nil or (obs_mode ~= 0 and obs_mode ~= 4)) then
                    return {nil, nil, nil}
                end
                local angles = _g.engine.GetViewAngles()
                if (angles == nil) then
                    return {nil, nil, nil}
                end
                return {angles.pitch, angles.yaw, angles.roll}
            end), _default.hlimit)
        end

        -- if (_client.lcl and _client.plr) then
        --     local entity = _client.plr
        --     local index = entity:GetIndex()
        --     _util.hnext(_history, _ht.dangles, index, _util.hsupp(function()
        --         local is_alive = entity:IsAlive()
        --         if (not is_alive) then
        --             return {nil, nil, nil}
        --         end
        --         local angles = _util.hget(_history, _ht.angles, index)
        --         if (angles == nil) then
        --             return {nil, nil, nil}
        --         end
        --         local pangles = angles[2]
        --         if (pangles == nil) then
        --             return {nil, nil, nil}
        --         end
        --         local cangles = angles[1]
        --         if (cangles == nil) then
        --             return {nil, nil, nil}
        --         end
        --         local ppitch = pangles[1]
        --         local cpitch = cangles[1]
        --         local dpitch = nil
        --         if (ppitch ~= nil and cpitch ~= nil) then
        --             dpitch = cpitch - ppitch
        --         end
        --         local pyaw = pangles[2]
        --         local cyaw = cangles[2]
        --         local dyaw = nil
        --         if (pyaw ~= nil and cyaw ~= nil) then
        --             dyaw = cyaw - pyaw
        --         end
        --         local proll = pangles[3]
        --         local croll = cangles[3]
        --         local droll = nil
        --         if (proll ~= nil and croll ~= nil) then
        --             droll = croll - proll
        --         end
        --         return {dpitch, dyaw, droll}
        --     end), _default.hlimit)
        -- end

        -- if (_client.lcl and _client.plr) then
        --     local entity = _client.plr
        --     local index = entity:GetIndex()
        --     _util.hnext(_history, _ht.pangle, index, _util.hsupp(function()
        --         local is_alive = entity:IsAlive()
        --         if (not is_alive) then
        --             return nil
        --         end
        --         local vel = _util.hget(_history, _ht.vel, index)[1]
        --         if (vel == nil) then
        --             return nil
        --         end
        --         local vel_x = vel[1]
        --         if (vel_x == nil) then
        --             return nil
        --         end
        --         local vel_y = vel[2]
        --         if (vel_y == nil) then
        --             return nil
        --         end
        --         return _util.pangle(tonumber(_g.client.GetConVar(_con.wish_speed)), math.sqrt(vel_x^2 + vel_y^2))
        --     end), _default.hlimit)
        -- end

        for _, entity in pairs(entlist) do
            local index = entity:GetIndex()
            _util.hnext(_history, _ht.flags, index, _util.hsupp(function()
                local is_alive = entity:IsAlive()
                if (not is_alive) then
                    return nil
                end
                return entity:GetPropInt(_prop.flags)
            end), _default.hlimit)
        end

        for _, entity in pairs(entlist) do
            local index = entity:GetIndex()
            _util.hnext(_history, _ht.ground, index, _util.hpred(function()
                local is_alive = entity:IsAlive()
                if (not is_alive) then
                    return nil
                end
                local flags = _util.hget(_history, _ht.flags, index)[1]
                if (flags == nil) then
                    return nil
                end
                return bit.band(flags, _flag.on_ground) == _flag.on_ground
            end), _default.hlimit)
        end

        for _, entity in pairs(entlist) do
            local index = entity:GetIndex()
            _util.hnext(_history, _ht.duck, index, _util.hpred(function()
                local is_alive = entity:IsAlive()
                if (not is_alive) then
                    return nil
                end
                local flags = _util.hget(_history, _ht.flags, index)[1]
                if (flags == nil) then
                    return nil
                end
                return bit.band(flags, _flag.ducking) == _flag.ducking
            end), _default.hlimit)
        end

        for _, entity in pairs(entlist) do
            local index = entity:GetIndex()
            _util.hnext(_history, _ht.scope, index, _util.hpred(function()
                local is_alive = entity:IsAlive()
                if (not is_alive) then
                    return nil
                end
                return entity:GetPropBool(_prop.scope)
            end), _default.hlimit)
        end

        for _, entity in pairs(entlist) do
            local index = entity:GetIndex()
            _util.hnext(_history, _ht.ladder, index, _util.hpred(function()
                local is_alive = entity:IsAlive()
                if (not is_alive) then
                    return nil
                end
                local render_mode = entity:GetPropInt(_prop.render_mode)
                if (render_mode == nil) then
                    return nil
                end
                return render_mode == _render.ladder
            end), _default.hlimit)
        end

        if (_client.lcl) then
            local entity = _client.lcl
            local index = entity:GetIndex()
            _util.hnext(_history, _ht.lag, index, _util.hpred(function()
                local is_alive = entity:IsAlive()
                if (not is_alive) then
                    return nil
                end
                local ladder = _util.hget(_history, _ht.ladder, index)[1]
                if (ladder == nil) then
                    return nil
                end
                return ladder > 0 and bit.band(cmd.buttons, _button.in_jump) == _button.in_jump
            end), _default.hlimit)
        end

        for _, entity in pairs(entlist) do
            local index = entity:GetIndex()
            _util.hnext(_history, _ht.vel, index, _util.hsupp(function()
                local is_alive = entity:IsAlive()
                if (not is_alive) then
                    return nil
                end
                local x = entity:GetPropFloat("localdata", _prop.vel_x)
                local y = entity:GetPropFloat("localdata", _prop.vel_y)
                local z = entity:GetPropFloat("localdata", _prop.vel_z)
                return {x, y, z}
            end), _default.hlimit)
        end

        for _, entity in pairs(entlist) do
            local index = entity:GetIndex()
            _util.hnext(_history, _ht.ps, index, _util.hpred(function()
                local is_alive = entity:IsAlive()
                if (not is_alive) then
                    return nil
                end
                local flags = _util.hget(_history, _ht.flags, index)[1]
                if (flags == nil) then
                    return nil
                end
                local ground = _util.hget(_history, _ht.ground, index)[1]
                if (ground == nil) then
                    return nil
                end
                local ladder = _util.hget(_history, _ht.ladder, index)[1]
                if (ladder == nil) then
                    return nil
                end
                local velocity = _util.hget(_history, _ht.vel, index)[1]
                if (velocity == nil) then
                    return nil
                end
                local velocity_z = velocity[3]
                if (velocity_z == nil) then
                    return nil
                end
                return ground < 0 and not (ladder > 0 or bit.band(flags, _flag.water_jump) == _flag.water_jump or bit.band(flags, _flag.swim) == _flag.swim or bit.band(flags, _flag.in_water) == _flag.in_water) and velocity_z == -6.25
            end), _default.hlimit)
        end

        for _, entity in pairs(entlist) do
            local index = entity:GetIndex()
            _util.hnext(_history, _ht.jt, index, _util.hsupp(function()
                local is_alive = entity:IsAlive()
                if (not is_alive) then
                    return nil
                end
                local pjt = _util.hget(_history, _ht.jt, index)[1]
                local pss = _util.hget(_history, _ht.ps, index)
                local pps = pss ~= nil and pss[2] or nil
                local cps = pss ~= nil and pss[1] or nil
                local grounds = _util.hget(_history, _ht.ground, index)
                local pground = grounds ~= nil and grounds[2] or nil
                local cground = grounds ~= nil and grounds[1] or nil
                local vels = _util.hget(_history, _ht.vel, index)
                -- local pvel_x = (vels ~= nil and vels[2] ~= nil) and vels[2][1] or nil
                local cvel_x = (vels ~= nil and vels[1] ~= nil) and  vels[1][1] or nil
                -- local pvel_y = (vels ~= nil and vels[2] ~= nil) and vels[2][2] or nil
                local cvel_y = (vels ~= nil and vels[1] ~= nil) and vels[1][2] or nil
                local pvel_z = (vels ~= nil and vels[2] ~= nil) and vels[2][3] or nil
                local pvel_z2 = (vels ~= nil and vels[3] ~= nil) and vels[3][3] or nil
                local cvel_z = (vels ~= nil and vels[1] ~= nil) and vels[1][3] or nil
                local utrace = _util.hget(_history, _ht.utrace, index)[1]
                local ducks = _util.hget(_history, _ht.duck, index)
                local pduck = ducks ~= nil and ducks[2] or nil
                local cduck = ducks ~= nil and ducks[1] or nil
                local ladders = _util.hget(_history, _ht.ladder, index)
                local pladder = ladders ~= nil and ladders[2] or nil
                local cladder = ladders ~= nil and ladders[1] or nil
                local lags = _util.hget(_history, _ht.lag, index)
                local plag = lags ~= nil and lags[2] or nil
                local clag = lags ~= nil and lags[1] or nil
                local pre_duck = _util.hget(_history, _ht.pre_duck, index)[1]
                local pre_flags = _util.hget(_history, _ht.pre_flags, index)[1]

                local flags = _util.hget(_history, _ht.flags, index)[1]
                local is_ignored_flags = flags ~= nil and (bit.band(flags, _flag.water_jump) == _flag.water_jump or bit.band(flags, _flag.swim) == _flag.swim or bit.band(flags, _flag.in_water) == _flag.in_water)
                local is_ignored_movetype = (cladder ~= nil and cladder > 0) or is_ignored_flags

                local is_pixel_surfed = (cps ~= nil and cps < 0) and (pps ~= nil and pps > 1)
                local is_edge_bugged = (cps ~= nil and cps < 0) and (pps ~= nil and pps == 1) and ((cground ~= nil and cground == 1) and (cvel_z ~= nil and cvel_z == 0) or (pground ~= nil and pground < -1) and (cground ~= nil and cground < -2)) and (utrace == nil or utrace.fraction * _default.tlen > 0.2)
                local is_head_hitted = (cps ~= nil and cps < 0) and (pps ~= nil and pps == 1) and ((cground ~= nil and cground == 1) and (cvel_z ~= nil and cvel_z == 0) or (pground ~= nil and pground < -1) and (cground ~= nil and cground < -2)) and (utrace ~= nil and utrace.fraction * _default.tlen < 0.2)
                local is_jump_bugged = (pre_duck ~= nil and pre_duck > 0) and (cduck ~= nil and cduck < 0) and not is_ignored_movetype and (cground ~= nil and cground < 0) and ((pvel_z ~= nil and pvel_z < 0) or (pvel_z ~= nil and pvel_z == 0 and pvel_z2 ~= nil and pvel_z2 < 0)) and (cvel_z ~= nil and cvel_z > 0)
                local is_ladder_jumped = (cladder ~= nil and cladder < 0) and (pladder ~= nil and pladder > 0)
                local is_ladder_glided = (clag ~= nil and clag < 0) and (plag ~= nil and plag > 0)
                local is_ladder_hopped = is_ladder_jumped and (cground ~= nil and cground == -1) and (pground ~= nil and pground > 0)

                if ((cground ~= nil and cground > 1) or is_ignored_flags) then
                    return _jt.none
                end
                if (is_ladder_hopped) then
                    return _jt.lah
                end
                if (is_ladder_glided) then
                    return _jt.lag
                end
                if (is_ladder_jumped) then
                    return _jt.laj
                end
                if (is_jump_bugged) then
                    return _jt.jb
                end
                if (is_pixel_surfed) then
                    return _jt.ps
                end
                if (is_edge_bugged) then
                    return _jt.eb
                end
                if (is_head_hitted) then
                    return _jt.hh
                end
                if ((cground ~= nil and cground == -1) and (cladder ~= nil and cladder < 0)) then
                    if ((pground ~= nil and pground == 1) or ((pground ~= nil and pground == 2 or pground == 3) and (pduck ~= nil and pduck == 1) and (cduck ~= nil and cduck == 2))) then
                        print(tostring(pre_flags) .. " | " .. tostring(pre_duck))
                        return _jt.perfect
                    else
                        return _jt.jump
                    end
                end

                return pjt
             end), _default.hlimit)
        end

        for _, entity in pairs(entlist) do
            local index = entity:GetIndex()
            _util.hnext(_history, _ht.specs, index, _util.hsupp(function()
                local spectators = {}
                for _, v in pairs(entlist) do
                    if (not v:IsAlive()) then
                        local target = v:GetPropEntity(_prop.obs_target)
                        if (target) then
                            if (index == target:GetIndex()) then
                                table.insert(spectators, v)
                            end
                        end
                    end
                end
                return #spectators == 0 and nil or spectators
            end), _default.hlimit)
        end
    end,

    function(cmd)
        if (_ui.jb_checkbox:GetValue()) then
            local jb_button = _g.gui.GetValue(_var.jb)
            if (not _ref.menu:IsActive()) then
                if (_client.lcl and _client.lcl:IsAlive()) then
                    local jb_type = _ui.jbt[_ui.jbt.keys[_ui.jb_type_combobox:GetValue() + 1]]
                    if (jb_type == _jbt.standard) then
                        local index = _client.lcl:GetIndex()
                        local ground = _util.hget(_history, _ht.ground, index)[1]
                        local ladder = _util.hget(_history, _ht.ladder, index)[1]
                        if ((ground ~= nil and ground > (_ui.jb_auto_jump_checkbox:GetValue() and 1 or 0)) or (ladder ~= nil and ladder > 0)) then
                            if (jb_button ~= 0) then
                                _context.jb_button = jb_button
                                _g.gui.SetValue(_var.jb, 0)
                            end
                        elseif (_context.jb_button ~= 0) then
                            _g.gui.SetValue(_var.jb, _context.jb_button)
                        end
                        if (_ui.jb_lag_checkbox:GetValue() and (ladder ~= nil and ladder > 0) and _context.jb_button ~= 0 and _g.input.IsButtonDown(_context.jb_button)) then
                            cmd.buttons = bit.bor(cmd.buttons, _button.in_jump)
                        end
                    elseif (jb_type == _jbt.improved) then
                        if (jb_button ~= 0) then
                            _context.jb_button = jb_button
                            _g.gui.SetValue(_var.jb, 0)
                        end
                        if (_g.input.IsButtonDown(_context.jb_button)) then
                            local flags = _client.lcl:GetPropInt(_prop.flags)
                            local pre_flags = _util.hget(_history, _ht.pre_flags, _client.lcl:GetIndex())[1]
                            if ((pre_flags ~= nil and bit.band(pre_flags, _flag.on_ground) ~= _flag.on_ground) and (flags ~= nil and bit.band(flags, _flag.on_ground) == _flag.on_ground)) then
                                cmd.buttons = bit.bor(cmd.buttons, _button.in_duck)
                            end
                        end
                    end
                elseif (jb_button == 0 and _context.jb_button ~= 0) then
                    _g.gui.SetValue(_var.jb, _context.jb_button)
                end
            elseif (jb_button == 0 and _context.jb_button ~= 0) then
                _g.gui.SetValue(_var.jb, _context.jb_button)
            end
        end
    end,

    function(cmd)
        if (_ui.laj_checkbox:GetValue() and _client.lcl and _client.lcl:IsAlive()) then
            local index = _client.lcl:GetIndex()
            local hladder = _util.hget(_history, _ht.ladder, index)
            local cladder = hladder ~= nil and hladder[1] or nil
            local pladder = hladder ~= nil and hladder[2] or nil
            local ground = _util.hget(_history, _ht.ground, index)[1]
            if ((cladder ~= nil and cladder < 0) and (pladder ~= nil and pladder > 0) and (_ui.laj_ground_checkbox:GetValue() or (ground ~= nil and ground < 0))) then
                local moves = _util.hget(_history, _ht.moves, index)[1]
                local sw_move = moves ~= nil and moves[2] or 0
                if (sw_move ~= 0) then
                    local fw_move = moves ~= nil and moves[1] or 0
                    if (fw_move > 0) then
                        local fw_alias = _ui.laj_alias_fw_editbox:GetValue()
                        if (fw_alias == nil or fw_alias == "") then
                            fw_alias = _default.laj_fw_alias
                        end
                        _g.client.Command(fw_alias, true)
                    elseif (fw_move < 0) then
                        local bw_alias = _ui.laj_alias_bw_editbox:GetValue()
                        if (bw_alias == nil or bw_alias == "") then
                            bw_alias = _default.laj_bw_alias
                        end
                        _g.client.Command(bw_alias, true)
                    end
                end
            end
        end
    end,

    function(cmd)
        if (_ui.ej_checkbox:GetValue() and _client.lcl and _client.lcl:IsAlive() and _g.input.IsButtonDown(_g.gui.GetValue(_var.ej))) then
            local index = _client.lcl:GetIndex()
            local hground = _util.hget(_history, _ht.ground, index)
            local cground = hground ~= nil and hground[1] or nil
            local pground = hground ~= nil and hground[2] or nil
            if ((cground ~= nil and cground == -1) and (pground ~= nil and pground > 0)) then
                local moves = _util.hget(_history, _ht.moves, index)[1]
                local fw_move = moves ~= nil and moves[1] or 0
                local sw_move = moves ~= nil and moves[2] or 0
                if (fw_move > 0) then
                    local fw_alias = _ui.ej_alias_fw_editbox:GetValue()
                    if (fw_alias == nil or fw_alias == "") then
                        fw_alias = _default.ej_fw_alias
                    end
                    _g.client.Command(fw_alias, true)
                elseif (fw_move < 0) then
                    local bw_alias = _ui.ej_alias_bw_editbox:GetValue()
                    if (bw_alias == nil or bw_alias == "") then
                        bw_alias = _default.ej_bw_alias
                    end
                    _g.client.Command(bw_alias, true)
                elseif (sw_move > 0) then
                    local rt_alias = _ui.ej_alias_rt_editbox:GetValue()
                    if (rt_alias == nil or rt_alias == "") then
                        rt_alias = _default.ej_rt_alias
                    end
                    _g.client.Command(rt_alias, true)
                elseif (sw_move < 0) then
                    local lt_alias = _ui.ej_alias_lt_editbox:GetValue()
                    if (lt_alias == nil or lt_alias == "") then
                        lt_alias = _default.ej_lt_alias
                    end
                    _g.client.Command(lt_alias, true)
                end
            end
        end
    end,

    function(cmd)
        if (_client.lcl and _client.lcl:IsAlive() and bit.band(cmd.buttons, _button.in_jump) == _button.in_jump) then
            local index = _client.lcl:GetIndex()
            local hground = _util.hget(_history, _ht.ground, index)
            local cground = hground ~= nil and hground[1] or nil
            local pground = hground ~= nil and hground[2] or nil
            if ((cground ~= nil and cground == -1) and (_ui.lj_checkbox:GetValue() and _g.input.GetMouseWheelDelta() == 0 and (pground ~= nil and pground > _ui.lj_ticks_slider:GetValue()) or _ui.lj_scroll_checkbox:GetValue() and _g.input.GetMouseWheelDelta() ~= 0 and (pground ~= nil and pground >= _ui.lj_scroll_ticks_slider:GetValue()))) then
                local moves = _util.hget(_history, _ht.moves, index)[1]
                local fw_move = moves ~= nil and moves[1] or 0
                local sw_move = moves ~= nil and moves[2] or 0
                if (fw_move > 0) then
                    local fw_alias = _ui.lj_alias_fw_editbox:GetValue()
                    if (fw_alias == nil or fw_alias == "") then
                        fw_alias = _default.lj_fw_alias
                    end
                    _g.client.Command(fw_alias, true)
                elseif (fw_move < 0) then
                    local bw_alias = _ui.lj_alias_bw_editbox:GetValue()
                    if (bw_alias == nil or bw_alias == "") then
                        bw_alias = _default.lj_bw_alias
                    end
                    _g.client.Command(bw_alias, true)
                elseif (sw_move > 0) then
                    local rt_alias = _ui.lj_alias_rt_editbox:GetValue()
                    if (rt_alias == nil or rt_alias == "") then
                        rt_alias = _default.lj_rt_alias
                    end
                    _g.client.Command(rt_alias, true)
                elseif (sw_move < 0) then
                    local lt_alias = _ui.lj_alias_lt_editbox:GetValue()
                    if (lt_alias == nil or lt_alias == "") then
                        lt_alias = _default.lj_lt_alias
                    end
                    _g.client.Command(lt_alias, true)
                end
            end
        end
    end,

    function(cmd)
        if (_ui.spread_checkbox:GetValue() and _client.plr) then
            local index = _client.plr:GetIndex()
            local scope = _util.hget(_history, _ht.scope, index)[1]
            if ((not _ui.spread_hide_checkbox:GetValue() or (scope ~= nil and scope < 0)) and (_util.in_range(tonumber(_g.client.GetConVar(_con.crosshair_style)), 2, 3) and (_client.lcl and _client.lcl:IsAlive()))) then
                local inncauracy = _client.plr:GetWeaponInaccuracy()
                local is_enabled = (inncauracy ~= nil and inncauracy or 0) > _ui.spread_start_slider:GetValue()
                _g.client.SetConVar(_con.debug_spread, is_enabled and 1 or _default.debug_spread, true)
            else
                _g.client.SetConVar(_con.debug_spread, (scope ~= nil and scope > 0) and _default.debug_spread or 2, true)
            end
        elseif (tonumber(_g.client.GetConVar(_con.debug_spread)) ~= _default.debug_spread) then
            _g.client.SetConVar(_con.debug_spread, _default.debug_spread, true)
        end
    end,

    function(cmd)
        if (_ui.wpn_sway_checkbox:GetValue()) then
            _g.client.SetConVar(_con.wpn_sway, _ui.wpn_sway_scale_slider:GetValue(), true)
        elseif (tonumber(_g.client.GetConVar(_con.wpn_sway)) ~= _default.wpn_sway) then
            _g.client.SetConVar(_con.wpn_sway, _default.wpn_sway, true)
        end
    end,

    function(cmd)
        local ui_font_name = _ui.global_font_name_combobox
        local ui_font_size = _ui.global_font_size_slider
        local ui_font_weight = _ui.global_font_weight_slider
        if (_ui.speed_font_checkbox:GetValue()) then
            ui_font_name = _ui.speed_font_name_combobox
            ui_font_size = _ui.speed_font_size_slider
            ui_font_weight = _ui.speed_font_weight_slider
        end
        _context.speed_font = _util.fnext(_font, _ui.font.keys[ui_font_name:GetValue() + 1], ui_font_size:GetValue(), ui_font_weight:GetValue())
    end,

    function(cmd)
        if (_ui.speed_shadow_checkbox:GetValue()) then
            _context.speed_shadow_offset_x = _ui.speed_shadow_offset_x_slider:GetValue()
            _context.speed_shadow_offset_y = _ui.speed_shadow_offset_y_slider:GetValue()
            local color = {_ui.speed_shadow_color:GetValue()}
            local saturation = _ui.speed_shadow_saturation_slider:GetValue()
            local brightness = _ui.speed_shadow_brightness_slider:GetValue()
            local h, s, b, a = _util.rgb_to_hsb(unpack(color))
            _context.speed_shadow_color = {_util.hsb_to_rgb(h, s * saturation, b * brightness, a)}
        elseif (_ui.global_shadow_checkbox:GetValue()) then
            _context.speed_shadow_offset_x = _ui.global_shadow_offset_x_slider:GetValue()
            _context.speed_shadow_offset_y = _ui.global_shadow_offset_y_slider:GetValue()
            local color = {_ui.global_shadow_color:GetValue()}
            local saturation = _ui.global_shadow_saturation_slider:GetValue()
            local brightness = _ui.global_shadow_brightness_slider:GetValue()
            local h, s, b, a = _util.rgb_to_hsb(unpack(color))
            _context.speed_shadow_color = {_util.hsb_to_rgb(h, s * saturation, b * brightness, a)}
        else
            _context.speed_shadow_offset_x = nil
            _context.speed_shadow_offset_y = nil
            _context.speed_shadow_color = nil
        end
    end,

    function(cmd)
        if (_ui.speed_rbow_checkbox:GetValue()) then
            local cycle_time = _ui.speed_rbow_cycle_slider:GetValue()
            local hue_shift = _ui.speed_rbow_shift_slider:GetValue()
            local hue_factor = cycle_time / _g.globals.TickInterval()
            local hue_value = _g.globals.TickCount()
            local saturation = _ui.speed_rbow_saturation_slider:GetValue()
            local brightness = _ui.speed_rbow_brightness_slider:GetValue()
            local hue = math.fmod(math.fmod(hue_value, hue_factor) / hue_factor + hue_shift, 1)
            _context.speed_color = {_util.hsb_to_rgb(hue, saturation, brightness, 1)}
        elseif (_ui.global_rbow_checkbox:GetValue()) then
            local cycle_time = _ui.global_rbow_cycle_slider:GetValue()
            local hue_shift = _ui.global_rbow_shift_slider:GetValue()
            local hue_factor = cycle_time / _g.globals.TickInterval()
            local hue_value = _g.globals.TickCount()
            local saturation = _ui.global_rbow_saturation_slider:GetValue()
            local brightness = _ui.global_rbow_brightness_slider:GetValue()
            local hue = math.fmod(math.fmod(hue_value, hue_factor) / hue_factor + hue_shift, 1)
            _context.speed_color = {_util.hsb_to_rgb(hue, saturation, brightness, 1)}
        elseif (_client.plr) then
            local index = _client.plr:GetIndex()
            local vels = _util.hget(_history, _ht.vel, index)
            if (vels ~= nil) then
                local cvel = vels[1]
                local pvel = vels[2]
                if (cvel ~= nil and pvel ~= nil) then
                    local cx = cvel[1]
                    local cy = cvel[2]
                    local px = pvel[1]
                    local py = pvel[2]
                    if (cx ~= nil and cy ~= nil and px ~= nil and py ~= nil) then
                        local cspeed = _util.vlen2(cx, cy)
                        local pspeed = _util.vlen2(px, py)
                        local dspeed = cspeed - pspeed
                        local cladder = _util.hget(_history, _ht.ladder, index)[1]
                        local cground = _util.hget(_history, _ht.ground, index)[1]
                        if (dspeed >= 0) then
                            if (cspeed >= ((cladder ~= nil and cladder > 0) and _ui.speed_far_ladder_slider:GetValue() or _ui.speed_far_slider:GetValue())) then
                                _context.speed_color = {_ui.speed_far_color:GetValue()}
                            elseif ((not _ui.speed_neutral_color_disable_in_air_checkbox:GetValue() and (cground ~= nil and cground < 0) or (cground ~= nil and cground > _ui.speed_neutral_color_ticks_slider:GetValue())) and math.abs(dspeed) <= _ui.speed_neutral_color_delta_error_slider:GetValue()) then
                                _context.speed_color = {_ui.speed_neutral_color:GetValue()}
                            elseif (dspeed > 0) then
                                _context.speed_color = {_ui.speed_positive_color:GetValue()}
                            end
                        elseif ((not _ui.speed_negative_color_disable_on_ground_checkbox:GetValue() and (cground ~= nil and cground > 0) or (cground ~= nil and cground < 0)) and not _util.in_range(math.abs(cground), 0, _ui.speed_negative_color_ticks_slider:GetValue()) and dspeed < -_ui.speed_negative_color_delta_error_slider:GetValue()) then
                            _context.speed_color = {_ui.speed_negative_color:GetValue()}
                        end
                    end
                end
            end
        else
            _context.speed_color = nil
        end
    end
}
_call.pre_move = {
    function(cmd)
        local entlist = _g.entities.FindByClass(_class.player)

        for _, entity in pairs(entlist) do
            local index = entity:GetIndex()
            _util.hnext(_history, _ht.pre_flags, index, _util.hsupp(function()
                local is_alive = entity:IsAlive()
                if (not is_alive) then
                    return nil
                end
                return entity:GetPropInt(_prop.flags)
            end), _default.hlimit)
        end

        for _, entity in pairs(entlist) do
            local index = entity:GetIndex()
            _util.hnext(_history, _ht.pre_duck, index, _util.hpred(function()
                local is_alive = entity:IsAlive()
                if (not is_alive) then
                    return nil
                end
                local pre_flags = _util.hget(_history, _ht.pre_flags, index)[1]
                if (pre_flags == nil) then
                    return nil
                end
                return bit.band(pre_flags, _flag.ducking) == _flag.ducking
            end), _default.hlimit)
        end
    end
}
_call.post_move = {
}
_call.draw = {
    function()
        _screen.width, _screen.height = _g.draw.GetScreenSize()
    end,

    function()
        if (_client.plr and _ui.speed_checkbox:GetValue() and _context.speed_font and _context.speed_color ~= nil and _screen.width ~= nil and _screen.height ~= nil) then
            local index = _client.plr:GetIndex()
            local cscope = _util.hget(_history, _ht.scope, index)[1]
            if (not _ui.speed_hide_checkbox:GetValue() or (cscope ~= nil and cscope < 0)) then
                local velocity = _util.hget(_history, _ht.vel, index)[1]
                if (velocity ~= nil) then
                    local speed_x = velocity[1]
                    if (speed_x == nil) then
                        speed_x = 0
                    end
                    local speed_y = velocity[2]
                    if (speed_y == nil) then
                        speed_y = 0
                    end
                    local speed_z = velocity[3]
                    if (speed_z == nil) then
                        speed_z = 0
                    end
                    local speed = 0
                    local cground = _util.hget(_history, _ht.ground, index)[1]
                    local cladder = _util.hget(_history, _ht.ladder, index)[1]
                    local cglide = _util.hget(_history, _ht.lag, index)[1]
                    if (_ui.speed_ladder_checkbox:GetValue() and (cladder ~= nil and cladder > 0) and (cground ~= nil and cground < 0) and (cglide ~= nil and cglide < 0)) then
                        speed = math.abs(speed_z)
                    else
                        if (not _ui.speed_x_checkbox:GetValue()) then
                            speed_x = 0
                        end
                        if (not _ui.speed_y_checkbox:GetValue()) then
                            speed_y = 0
                        end
                        if (not _ui.speed_z_checkbox:GetValue()) then
                            speed_z = 0
                        end
                        speed = _util.vlen3(speed_x, speed_y, speed_z)
                    end
                    local accuracy = _ui.speed_accuracy_slider:GetValue()
                    local zeros = _ui.speed_zeros_slider:GetValue()
                    if (accuracy ~= 0) then
                        zeros = zeros + accuracy + 1
                    end
                    local text = string.format("%0" .. tostring(zeros) .. "." .. tostring(accuracy) .. "f", speed)
                    local text_w, text_h = _g.draw.GetTextSize(text)
                    local text_x, text_y = _screen.width * _ui.speed_pos_x_slider:GetValue(), _screen.height * (1 - _ui.speed_pos_y_slider:GetValue())
                    text_x, text_y = text_x - text_w / 2, text_y - text_h / 2

                    _g.draw.SetFont(_context.speed_font)

                    if (_context.speed_shadow_offset_x ~= nil and _context.speed_shadow_offset_y ~= nil and _context.speed_shadow_color ~= nil) then
                        local shadow_x, shadow_y = text_x + _context.speed_shadow_offset_x, text_y + _context.speed_shadow_offset_y
                        _g.draw.Color(unpack(_context.speed_shadow_color))
                        _g.draw.Text(shadow_x, shadow_y, text)
                    end

                    _g.draw.Color(unpack(_context.speed_color))
                    _g.draw.Text(text_x, text_y, text)
                end
            end
        end
    end,

    function()
        if (_ui.debug_checkbox:GetValue()) then
            if (_client.plr) then
                local font = _util.fnext(_font, _ui.font.keys[_ui.global_font_name_combobox:GetValue() + 1], _ui.global_font_size_slider:GetValue(), _ui.global_font_weight_slider:GetValue())
                if (font) then
                    local space_w, space_h = _g.draw.GetTextSize(" ")

                    -- local velocity = _util.hget(_history, _ht.vel, _client.plr:GetIndex())[1]
                    -- if (velocity ~= nil) then
                    --     _g.draw.SetFont(_context.speed_font)

                    --     local speed_x = velocity[1] ~= nil and velocity[1] or 0
                    --     local speed_y = velocity[2] ~= nil and velocity[2] or 0
                    --     local speed = math.sqrt(speed_x^2 + speed_y^2)

                    --     local text = string.format("%03.0f", speed)
                    --     if (_ui.debug_pangle_checkbox:GetValue()) then
                    --         local pangle = _util.hget(_history, _ht.pangle, _client.plr:GetIndex())[1]
                    --         if (pangle ~= nil) then
                    --             local dangles = _util.hget(_history, _ht.dangles, _client.plr:GetIndex())[1]
                    --             if (dangles ~= nil) then
                    --                 local dyaw = dangles[2]
                    --                 if (dyaw ~= nil) then
                    --                     local ratio = math.abs(_util.nangle(dyaw) / pangle)
                    --                     text = text .. string.format(" [%03.0f]", ratio * 100)
                    --                 end
                    --             end
                    --         end
                    --     end

                    --     local text_w, text_h = _g.draw.GetTextSize(text)
                    --     local text_x, text_y = _screen.width * 50 / 100, _screen.height * (100 - 40) / 100
                    --     text_x, text_y = text_x - text_w / 2, text_y - text_h / 2

                    --     local shadow_x = text_x + _ui.global_shadow_offset_x_slider:GetValue()
                    --     local shadow_y = text_y + _ui.global_shadow_offset_y_slider:GetValue()
                    --     local shadow_staturation = _ui.global_shadow_saturation_slider:GetValue()
                    --     local shadow_brightness = _ui.global_shadow_brightness_slider:GetValue()
                    --     local h, s, b, a = _util.rgb_to_hsb(_ui.global_shadow_color:GetValue())
                    --     local shadow_color = {_util.hsb_to_rgb(h, s * shadow_staturation, b * shadow_brightness, a)}

                    --     _g.draw.Color(unpack(_context.speed_shadow_color))
                    --     _g.draw.Text(shadow_x, shadow_y, text)

                    --     _g.draw.Color(unpack(_context.speed_color))
                    --     _g.draw.Text(text_x, text_y, text)
                    -- end

                    _g.draw.SetFont(font)

                    if (_ui.debug_specs_checkbox:GetValue()) then
                        local speclist = _util.hget(_history, _ht.specs, _client.plr:GetIndex())[1]
                        if (speclist ~= nil) then
                            local curr_x, curr_y = space_w, space_h
                            for _, specent in ipairs(speclist) do
                                local spectext = specent:GetName()

                                _g.draw.Color(0, 0, 0, 255)
                                _g.draw.Text(curr_x + 1, curr_y + 1, spectext)

                                _g.draw.Color(0, 255, 0, 255)
                                _g.draw.Text(curr_x, curr_y, spectext)

                                local spectext_w, spectext_h = _g.draw.GetTextSize(spectext)

                                curr_x = curr_x + 0
                                curr_y = curr_y + spectext_h + space_h
                            end
                        end
                    end

                    if (_ui.debug_jt_checkbox:GetValue()) then
                        local jt = _util.hget(_history, _ht.jt, _client.plr:GetIndex())[1]
                        if (jt ~= nil) then
                            local text = tostring(_jt.names[jt])
                            local text_w, text_h = _g.draw.GetTextSize(text)
                            local text_x, text_y = _screen.width - text_w - space_w, space_h

                            local shadow_x = text_x + _ui.global_shadow_offset_x_slider:GetValue()
                            local shadow_y = text_y + _ui.global_shadow_offset_y_slider:GetValue()
                            local shadow_staturation = _ui.global_shadow_saturation_slider:GetValue()
                            local shadow_brightness = _ui.global_shadow_brightness_slider:GetValue()
                            local h, s, b, a = _util.rgb_to_hsb(_ui.global_shadow_color:GetValue())
                            local shadow_color = {_util.hsb_to_rgb(h, s * shadow_staturation, b * shadow_brightness, a)}

                            _g.draw.Color(unpack(shadow_color))
                            _g.draw.Text(shadow_x, shadow_y, text)

                            _g.draw.Color(0, 255, 0, 255)
                            _g.draw.Text(text_x, text_y, text)
                        end
                    end
                end
            end
        end
    end
}

_g.callbacks.Register(_callback.move, function(cmd)
    for _, fn in ipairs(_call.move) do
        fn(cmd)
    end
end)

_g.callbacks.Register(_callback.pre_move, function(cmd)
    for _, fn in ipairs(_call.pre_move) do
        fn(cmd)
    end
end)

_g.callbacks.Register(_callback.post_move, function(cmd)
    for _, fn in ipairs(_call.post_move) do
        fn(cmd)
    end
end)

_g.callbacks.Register(_callback.draw, function()
    for _, fn in ipairs(_call.draw) do
        fn()
    end
end)
