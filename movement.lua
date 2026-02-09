local _g = {}
_g.gui = gui
_g.callbacks = callbacks
_g.client = client
_g.entities = entities
_g.input = input
_g.draw = draw
_g.engine = engine

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

_util.in_range = function(v, a, b)
    if (v == nil or a == nil or b == nil) then
        return nil
    end
    v = tonumber(v)
    a = tonumber(a)
    b = tonumber(b)
    return (v >= a and v <= b)
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

_util.vlen3 = function(x, y, z)
    x = tonumber(x)
    y = tonumber(y)
    z = tonumber(z)
    return math.sqrt(x^2 + y^2 + z^2)
end

_util.vlen2 = function(x, y)
    return _util.vlen3(x, y, 0)
end

local _jbt = {}
_jbt.standard = 1
_jbt.improved = 2

local _ref = {}
_ref.menu = _g.gui.Reference("Menu")
_ref.settings = _g.gui.Reference("Settings")

local _tab = {}
_tab.movement = _g.gui.Tab(_ref.settings, "settings.movement", "Movement")

local _ui = {}
_ui.jbt = _util.init_table({"Standard", "Improved"}, {_jbt.standard, _jbt.improved})
_ui.font = _util.init_table({"Consolas", "AcPlus IBM BIOS"}, {})

_ui.debug_checkbox = _g.gui.Checkbox(_tab.movement, "debug.checkbox", "Debug", false)
_ui.debug_checkbox:SetDescription("Show debug text on the screen.")

_ui.debug_color = _g.gui.ColorPicker(_tab.movement, "debug.color", "Debug Color", 0, 255, 0, 255)

_ui.debug_specs_checkbox = _g.gui.Checkbox(_tab.movement, "debug.specs.checkbox", "Debug Spectators", false)
_ui.debug_specs_checkbox:SetDescription("Show list of spectators on the left top corner of the screen.")

_ui.debug_specs_self_checkbox = _g.gui.Checkbox(_tab.movement, "debug.specs.self.checkbox", "Debug Spectators Self", false)
_ui.debug_specs_self_checkbox:SetDescription("Show yourself on the list of spectators on the left top corner of the screen.")

_ui.debug_jt_checkbox = _g.gui.Checkbox(_tab.movement, "debug.jt.checkbox", "Debug Jump Type", false)
_ui.debug_jt_checkbox:SetDescription("Show debug text on the right top corner of the screen with current jump type.")

_ui.spread_checkbox = _g.gui.Checkbox(_tab.movement, "spread.show.checkbox", "Spread", true)
_ui.spread_checkbox:SetDescription("Show weapon spread using the `weapon_debug_spread_show` console variable.")

_ui.spread_hide_checkbox = _g.gui.Checkbox(_tab.movement, "spread.hide.checkbox", "Spread Hide", false)
_ui.spread_hide_checkbox:SetDescription("Hide weapon spread while scroping using the `weapon_debug_spread_show` console variable.")

_ui.spread_start_slider = _g.gui.Slider(_tab.movement, "spread.start.slider", "Spread Start", 0.01, 0, 1, 0.005)
_ui.spread_start_slider:SetDescription("Innacuracy value of current weapon from which to start showing the weapon spread.")

_ui.sway_checkbox = _g.gui.Checkbox(_tab.movement, "sway.checkbox", "Sway", false)
_ui.sway_checkbox:SetDescription("Override the `cl_wpn_sway_scale` console variable.")

_ui.sway_scale_slider = _g.gui.Slider(_tab.movement, "sway.scale.slider", "Sway Scale", 0, 0, 1.6, 0.01)
_ui.sway_scale_slider:SetDescription("Set value of the `cl_wpn_sway_scale` console variable.")

_ui.jb_checkbox = _g.gui.Checkbox(_tab.movement, "jb.checkbox", "Jump-Bug", true)
_ui.jb_checkbox:SetDescription("Disable the auto jump-bug on the ground and enable it in the air.")

_ui.jb_auto_jump_checkbox = _g.gui.Checkbox(_tab.movement, "jb.autojump.checkbox", "Jump-Bug Auto Jump", true)
_ui.jb_auto_jump_checkbox:SetDescription("Switch the jump-bug's auto jump, if disabled, it will supress the auto jump after a failed jump-bug.")

_ui.jb_type_combobox = _g.gui.Combobox(_tab.movement, "jb.type.combobox", "Jump-Bug Type", unpack(_ui.jbt.keys))
_ui.jb_type_combobox:SetDescription("Switch an implementation of the auto jump-bug feature.")

_ui.jb_lag_checkbox = _g.gui.Checkbox(_tab.movement, "jb.lag.checkbox", "Jump-Bug Ladder Glide", true)
_ui.jb_lag_checkbox:SetDescription("Set in-jump button when holding the jump-bug key while ladder moving.")

_ui.lj_checkbox = _g.gui.Checkbox(_tab.movement, "lj.checkbox", "Long Jump", true)
_ui.lj_checkbox:SetDescription("Release +forward or +back or +moveright or +moveleft at start of a long jump.")

_ui.lj_ticks_slider = _g.gui.Slider(_tab.movement, "lj.ticks.slider", "Long Jump Ticks", 2, 2, 64)
_ui.lj_ticks_slider:SetDescription("Set how many ticks on the ground needed before doing a long jump.")

_ui.lj_scroll_checkbox = _g.gui.Checkbox(_tab.movement, "lj.scroll.checkbox", "Long Jump Scroll", false)
_ui.lj_scroll_checkbox:SetDescription("Release +forawrd or +back or +moveright or +moveleft at start of a scroll long jump.")

_ui.lj_scroll_ticks_slider = _g.gui.Slider(_tab.movement, "lj.scroll.ticks.slider", "Long Jump Scroll TIcks", 8, 2, 64)
_ui.lj_scroll_ticks_slider:SetDescription("Set how many ticks on the ground needed before doing a scroll jump.")

_ui.lj_alias_fw_editbox = _g.gui.Editbox(_tab.movement, "lj.alias.fw.editbox", "Long Jump Forward Alias")
_ui.lj_alias_fw_editbox:SetDescription("Set custom forward alias that will be executed at start of a long jump.")

_ui.lj_alias_bw_editbox = _g.gui.Editbox(_tab.movement, "lj.alias.bw.editbox", "Long Jump Back Alias")
_ui.lj_alias_bw_editbox:SetDescription("Set custom back alias that will be executed at start of a long jump.")

_ui.lj_alias_rt_editbox = _g.gui.Editbox(_tab.movement, "lj.alias.rt.editbox", "Long Jump Right Alias")
_ui.lj_alias_rt_editbox:SetDescription("Set custom right alias that will be executed at start of a long jump.")

_ui.lj_alias_lt_editbox = _g.gui.Editbox(_tab.movement, "lj.alias.lt.editbox", "Long Jump Left Alias")
_ui.lj_alias_lt_editbox:SetDescription("Set custom left alias that will be executed at start of a long jump.")

_ui.laj_checkbox = _g.gui.Checkbox(_tab.movement, "laj.checkbox", "Ladder Jump", true)
_ui.laj_checkbox:SetDescription("Release +forward or +back at start of a ladder jump.")

_ui.laj_ground_checkbox = _g.gui.Checkbox(_tab.movement, "laj.ground.checkbox", "Ladder Jump On Ground", false)
_ui.laj_ground_checkbox:SetDescription("Release +forward or +back at start of a ladder walk-off.")

_ui.laj_alias_fw_editbox = _g.gui.Editbox(_tab.movement, "laj.alias.fw.editbox", "Ladder Jump Forward Alias")
_ui.laj_alias_fw_editbox:SetDescription("Set custom forawrd alias that will be executed at start of a ladder jump.")

_ui.laj_alias_bw_editbox = _g.gui.Editbox(_tab.movement, "laj.alias.bw.editbox", "Ladder Jump Back Alias")
_ui.laj_alias_bw_editbox:SetDescription("Set custom back alias that will be executed at statrt of a ladder jump.")

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

_ui.global_shadow_color = _g.gui.ColorPicker(_tab.movement, "global.shadow.color", "Global Shadow Color", 0, 0, 0, 255)

_ui.global_shadow_saturation_slider = _g.gui.Slider(_tab.movement, "global.shadow.saturation.slider", "Global Shadow Saturation", 1, 0, 1, 0.01)
_ui.global_shadow_saturation_slider:SetDescription("Set the global shadow color saturation.")

_ui.global_shadow_brightness_slider = _g.gui.Slider(_tab.movement, "global.shadow.brightness.slider", "Global Shadow Brightness", 1, 0, 1, 0.01)
_ui.global_shadow_brightness_slider:SetDescription("Set the global shadow color brightness.")

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

_ui.speed_shadow_color =_g.gui.ColorPicker(_tab.movement, "speed.shadow.color", "Speed Shadow Color", 0, 0, 0, 255)

_ui.speed_shadow_saturation_slider = _g.gui.Slider(_tab.movement, "speed.shadow.saturation.slider", "Speed Shadow Saturation", 1, 0, 1, 0.01)
_ui.speed_shadow_saturation_slider:SetDescription("Set player's speed shadow color saturation.")

_ui.speed_shadow_brightness_slider = _g.gui.Slider(_tab.movement, "speed.shadow.brightness.slider", "Speed Shadow Brightness", 1, 0, 1, 0.01)
_ui.speed_shadow_brightness_slider:SetDescription("Set player's speed shadow color brightness.")

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

_ui.speed_far_color = _g.gui.ColorPicker(_tab.movement, "speed.far.color", "Speed Far Color", 255, 0, 255, 255)

_ui.speed_far_slider = _g.gui.Slider(_tab.movement, "speed.far.slider", "Speed Far Value", 340, 286, 480)
_ui.speed_far_slider:SetDescription("Set player's speed limit for a far value.")

_ui.speed_far_ladder_slider = _g.gui.Slider(_tab.movement, "speed.far.ladder.slider", "Speed Far Ladder Value", 310, 104, 312)
_ui.speed_far_ladder_slider:SetDescription("Set player's speed limit for a far value while ladder moving.")

_ui.speed_positive_color = _g.gui.ColorPicker(_tab.movement, "speed.positive.color", "Speed Positive Color", 0, 255, 0, 255)
_ui.speed_neutral_color = _g.gui.ColorPicker(_tab.movement, "speed.neutral.color", "Speed Neutral Color", 255, 255, 0, 255)
_ui.speed_negative_color = _g.gui.ColorPicker(_tab.movement, "speed.negative.color", "Speed Negative Color", 255, 0, 0, 255)

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

local _font = {}

local _class = {}
_class.player = "CCSPlayer"

local _var = {}
_var.jb = "misc.autojumpbug"

local _def = {}
_def.spread = 0
_def.sway = 1.6
_def.fw_alias = "-forward"
_def.bw_alias = "-back"
_def.rt_alias = "-moveright"
_def.lt_alias = "-moveleft"

local _dbg = {}
_dbg.font = _g.draw.CreateFont("Consolas", 20, 900)

local _cv = {}
_cv.spread = "weapon_debug_spread_show"
_cv.cross_style = "cl_crosshairstyle"
_cv.sway = "cl_wpn_sway_scale"

local _prop = {}
_prop.obs_target = "m_hObserverTarget"
_prop.scope = "m_bIsScoped"
_prop.flags = "m_fFlags"
_prop.render_mode = "m_nRenderMode"
_prop.vel_x = "m_vecVelocity[0]"
_prop.vel_y = "m_vecVelocity[1]"
_prop.vel_z = "m_vecVelocity[2]"

local _render = {}
_render.lcl_ladder = 2304
_render.trg_ladder = 2314

local _flag = {}
_flag.on_ground = 1
_flag.ducking = 2
_flag.water_jump = 8
_flag.in_water = 1024
_flag.swim = 4096

local _button = {}
_button.in_jump = 2
_button.in_duck = 4

local _call = {}
_call.move = "CreateMove"
_call.pre_move = "PreMove"
_call.draw = "Draw"
_call.unload = "Unload"

local _client = {}
_client.lcl = nil
_client.plr = nil
_client.trg = nil

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

local _context = {}
_context.screen_w = nil
_context.screen_h = nil
_context.jb_button = 0
_context.pre_flags = nil
_context.pre_duck = nil
_context.pground = 0
_context.cground = 0
_context.pduck = 0
_context.cduck = 0
_context.pladder = 0
_context.cladder = 0
_context.plag = 0
_context.clag = 0
_context.ppvelocity = nil
_context.pvelocity = nil
_context.cvelocity = nil
_context.pps = 0
_context.cps = 0
_context.jt = _jt.none
_context.spectators = nil
_context.speed_font = nil
_context.speed_shadow_offset_x = nil
_context.speed_shadow_offset_y = nil
_context.speed_shadow_color = nil
_context.speed_color = nil
_context.takeoff_velocity = nil

_g.callbacks.Register(_call.move, function(cmd)
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

    if (_client.plr and _client.plr:IsAlive()) then
        do
            local flags = _client.plr:GetPropInt(_prop.flags)
            _context.pground = _context.cground
            if (flags ~= nil) then
                if (bit.band(flags, _flag.on_ground) == _flag.on_ground) then
                    if (_context.cground < 0) then
                        _context.cground = 0
                    end
                    _context.cground = _context.cground + 1
                else
                    if (_context.cground > 0) then
                        _context.cground = 0
                    end
                    _context.cground = _context.cground - 1
                end
            else
                _context.cground = 0
            end
        end

        do
            local flags = _client.plr:GetPropInt(_prop.flags)
            _context.pduck = _context.cduck
            if (flags ~= nil) then
                if (bit.band(flags, _flag.ducking) == _flag.ducking) then
                    if (_context.cduck < 0) then
                        _context.cduck = 0
                    end
                    _context.cduck = _context.cduck + 1
                else
                    if (_context.cduck > 0) then
                        _context.cduck = 0
                    end
                    _context.cduck = _context.cduck - 1
                end
            else
                _context.cduck = 0
            end
        end

        do
            local render_mode = _client.plr:GetPropInt(_prop.render_mode)
            _context.pladder = _context.cladder
            if (render_mode ~= nil) then
                if (render_mode == _render.lcl_ladder or render_mode == _render.trg_ladder) then
                    if (_context.cladder < 0) then
                        _context.cladder = 0
                    end
                    _context.cladder = _context.cladder + 1
                else
                    if (_context.cladder > 0) then
                        _context.cladder = 0
                    end
                    _context.cladder = _context.cladder - 1
                end
            else
                _context.cladder = 0
            end
        end

        do
            _context.plag = _context.clag
            if (_context.cladder ~= 0) then
                if (_context.cladder > 0 and bit.band(cmd.buttons, _button.in_jump) == _button.in_jump) then
                    if (_context.clag < 0) then
                        _context.clag = 0
                    end
                    _context.clag = _context.clag + 1
                else
                    if (_context.clag > 0) then
                        _context.clag = 0
                    end
                    _context.clag = _context.clag - 1
                end
            else
                _context.clag = 0
            end
        end

        do
            _context.ppvelocity = _context.pvelocity
            _context.pvelocity = _context.cvelocity
            local x = _client.plr:GetPropFloat("localdata", _prop.vel_x)
            local y = _client.plr:GetPropFloat("localdata", _prop.vel_y)
            local z = _client.plr:GetPropFloat("localdata", _prop.vel_z)
            if (x == nil and y == nil and z == nil) then
                _context.cvelocity = nil
            else
                _context.cvelocity = {x, y, z}
            end
        end

        do
            local flags = _client.plr:GetPropInt(_prop.flags)
            _context.pps = _context.cps
            if (flags ~= nil) then
                local is_ignored = _context.cladder > 0 or bit.band(flags, _flag.water_jump) == _flag.water_jump or bit.band(flags, _flag.swim) == _flag.swim or bit.band(flags, _flag.in_water) == _flag.in_water
                if (_context.cground < 0 and (_context.cvelocity ~= nil and _context.cvelocity[3] == -6.25) and not is_ignored) then
                    if (_context.cps < 0) then
                        _context.cps = 0
                    end
                    _context.cps = _context.cps + 1
                else
                    if (_context.cps > 0) then
                        _context.cps = 0
                    end
                    _context.cps = _context.cps - 1
                end
            else
                _context.cps = 0
            end
        end
    end

    do
        local flags = _client.plr:GetPropInt(_prop.flags)
        local is_ignored_fl = flags ~= nil and (bit.band(flags, _flag.water_jump) == _flag.water_jump or bit.band(flags, _flag.swim) == _flag.swim or bit.band(flags, _flag.in_water) == _flag.in_water)
        local is_ignored_mt = _context.cladder > 0 and is_ignored_fl

        local is_pixel_surfed = _context.cps < 0 and _context.pps > 1
        local is_ladder_jumped = _context.cladder < 0 and _context.pladder > 0
        local is_ladder_glided = _context.clag < 0 and _context.plag > 0
        local is_ladder_hopped = is_ladder_jumped and _context.cground == -1 and _context.pground > 0
        local is_jump_bugged = (_context.pre_duck ~= nil and _context.pre_duck) and _context.cduck < 0 and _context.cground < 0 and ((_context.pvelocity ~= nil and _context.pvelocity[3] < 0) or (_context.pvelocity ~= nil and _context.pvelocity[3] == 0 and _context.ppvelocity ~= nil and _context.ppvelocity[3] < 0)) and (_context.cvelocity ~= nil and _context.cvelocity[3] > 0) and not is_ignored_mt

        if (_context.cground > 1 or is_ignored_fl) then
            _context.jt = _jt.none
            _context.takeoff_velocity = nil
        elseif (is_ladder_hopped) then
            _context.jt = _jt.lah
            _context.takeoff_velocity = _context.cvelocity
        elseif (is_ladder_glided) then
            _context.jt = _jt.lag
            _context.takeoff_velocity = _context.cvelocity
        elseif (is_ladder_jumped) then
            _context.jt = _jt.laj
            _context.takeoff_velocity = _context.cvelocity
        elseif (is_jump_bugged) then
            _context.jt = _jt.jb
            _context.takeoff_velocity = _context.cvelocity
        elseif (is_pixel_surfed) then
            _context.jt = _jt.ps
            _context.takeoff_velocity = _context.cvelocity
        elseif (_context.cground == -1 and _context.cladder < 0) then
            if (_context.pground == 1 or ((_context.pground == 2 or _context.pground == 3) and _context.pduck == 1 and _context.cduck == 2 and _context.pre_duck and bit.band(_context.pre_flags, _flag.on_ground) == _flag.on_ground)) then
                _context.jt = _jt.perfect
                _context.takeoff_velocity = _context.cvelocity
            else
                _context.jt = _jt.jump
                if (_context.pground == 1) then
                    _context.takeoff_velocity = _context.cvelocity
                else
                    _context.takeoff_velocity = _context.pvelocity
                end
            end
        end
    end

    if (_ui.spread_checkbox:GetValue() and _client.plr) then
        local scope = _client.plr:GetPropBool(_prop.scope)
        if ((not _ui.spread_hide_checkbox:GetValue() or (scope ~= nil and not scope)) and (_util.in_range(_g.client.GetConVar(_cv.cross_style), 2, 3) and (_client.lcl and _client.lcl:IsAlive()))) then
            local inncauracy = _client.plr:GetWeaponInaccuracy()
            local is_eanbled = (inncauracy ~= nil and inncauracy or 0) > _ui.spread_start_slider:GetValue()
            _g.client.SetConVar(_cv.spread, is_eanbled and 1 or _def.spread, true)
        else
            _g.client.SetConVar(_cv.spread, (scope ~= nil and scope) and _def.spread or 2, true)
        end
    elseif (tonumber(_g.client.GetConVar(_cv.spread)) ~= _def.spread) then
        _g.client.SetConVar(_cv.spread, _def.spread, true)
    end

    if (_ui.sway_checkbox:GetValue()) then
        _g.client.SetConVar(_cv.sway, _ui.sway_scale_slider:GetValue(), true)
    elseif (tonumber(_g.client.GetConVar(_cv.sway)) ~= _def.sway) then
        _g.client.SetConVar(_cv.sway, _def.sway, true)
    end

    if (_client.lcl and _client.lcl:IsAlive()) then
        if (bit.band(cmd.buttons, _button.in_jump) == _button.in_jump) then
            if (_context.cground == -1 and (_ui.lj_checkbox:GetValue() and _g.input.GetMouseWheelDelta() == 0 and _context.pground > _ui.lj_ticks_slider:GetValue() or _ui.lj_scroll_checkbox:GetValue() and _g.input.GetMouseWheelDelta() ~= 0 and _context.pground >= _ui.lj_scroll_ticks_slider:GetValue())) then
                local fw_move = cmd.forwardmove
                local sw_move = cmd.sidemove
                if (fw_move > 0) then
                    local fw_alias = _ui.lj_alias_fw_editbox:GetValue()
                    if (fw_alias == nil or fw_alias == "") then
                        fw_alias = _def.fw_alias
                    end
                    _g.client.Command(fw_alias, true)
                elseif (fw_move < 0) then
                    local bw_alias = _ui.lj_alias_bw_editbox:GetValue()
                    if (bw_alias == nil or bw_alias == "") then
                        bw_alias = _def.bw_alias
                    end
                    _g.client.Command(bw_alias, true)
                elseif (sw_move > 0) then
                    local rt_alias = _ui.lj_alias_rt_editbox:GetValue()
                    if (rt_alias == nil or rt_alias == "") then
                        rt_alias = _def.rt_alias
                    end
                    _g.client.Command(rt_alias, true)
                elseif (sw_move < 0) then
                    local lt_alias = _ui.lj_alias_lt_editbox:GetValue()
                    if (lt_alias == nil or lt_alias == "") then
                        lt_alias = _def.lt_alias
                    end
                    _g.client.Command(lt_alias, true)
                end
            end
        end

        if (_ui.laj_checkbox:GetValue()) then
            if (_context.cladder < 0 and _context.pladder > 0 and (_ui.laj_ground_checkbox:GetValue() or (_context.cground < 0))) then
                local fw_move = cmd.forwardmove
                if (fw_move > 0) then
                    local fw_alias = _ui.laj_alias_fw_editbox:GetValue()
                    if (fw_alias == nil or fw_alias == "") then
                        fw_alias = _def.fw_alias
                    end
                    _g.client.Command(fw_alias, true)
                elseif (fw_move < 0) then
                    local bw_alias = _ui.laj_alias_bw_editbox:GetValue()
                    if (bw_alias == nil or bw_alias == "") then
                        bw_alias = _def.bw_alias
                    end
                    _g.client.Command(bw_alias, true)
                end
            end
        end
    end

    if (_ui.jb_checkbox:GetValue()) then
        local jb_button = _g.gui.GetValue(_var.jb)
        if (not _ref.menu:IsActive()) then
            if (_client.lcl and _client.lcl:IsAlive()) then
                local jb_type = _ui.jbt[_ui.jbt.keys[_ui.jb_type_combobox:GetValue() + 1]]
                if (jb_type == _jbt.standard) then
                    if (_context.cground > (_ui.jb_auto_jump_checkbox:GetValue() and 1 or 0) or _context.cladder > 0) then
                        if (jb_button ~= 0) then
                            _context.jb_button = jb_button
                            _g.gui.SetValue(_var.jb, 0)
                        end
                    elseif (_context.jb_button ~= 0) then
                        _g.gui.SetValue(_var.jb, _context.jb_button)
                    end
                elseif (jb_type == _jbt.improved) then
                    if (jb_button ~= 0) then
                        _context.jb_button = jb_button
                        _g.gui.SetValue(_var.jb, 0)
                    end
                    if (_g.input.IsButtonDown(_context.jb_button)) then
                        if ((_context.pre_flags ~= nil and bit.band(_context.pre_flags, _flag.on_ground) ~= _flag.on_ground) and _context.cground > 0) then
                            cmd.buttons = bit.bor(cmd.buttons, _button.in_duck)
                        end
                    end
                end
                if (_ui.jb_lag_checkbox:GetValue() and _context.cladder > 0 and _context.jb_button ~= 0 and _g.input.IsButtonDown(_context.jb_button)) then
                    cmd.buttons = bit.bor(cmd.buttons, _button.in_jump)
                end
            elseif (jb_button == 0 and _context.jb_button ~= 0) then
                _g.gui.SetValue(_var.jb, _context.jb_button)
            end
        elseif (jb_button == 0 and _context.jb_button ~= 0) then
            _g.gui.SetValue(_var.jb, _context.jb_button)
        end
    end

    if (_client.plr and _client.plr:IsAlive()) then
        do
            _context.spectators = {}
            for _, entity in pairs(_g.entities.FindByClass(_class.player)) do
                local entity_index = entity:GetIndex()
                if (not entity:IsAlive() and (_ui.debug_specs_self_checkbox:GetValue() or entity_index ~= _client.lcl:GetIndex())) then
                    local target = entity:GetPropEntity(_prop.obs_target)
                    if (target) then
                        local target_index = target:GetIndex()
                        if (_client.plr:GetIndex() == target_index) then
                            local info = _g.client.GetPlayerInfo(target_index)
                            if (not info.IsBot and not info.IsGOTV) then
                                table.insert(_context.spectators, entity)
                            end
                        end
                    end
                end
            end
        end

        do
            local cspeed = nil
            if (_context.cvelocity ~= nil) then
                local x = _context.cvelocity[1]
                if (x == nil) then
                    x = 0
                end
                local y = _context.cvelocity[2]
                if (y == nil) then
                    y = 0
                end
                cspeed = _util.vlen2(x, y)
            end
            local pspeed = nil
            if (_context.pvelocity ~= nil) then
                local x = _context.pvelocity[1]
                if (x == nil) then
                    x = 0
                end
                local y = _context.pvelocity[2]
                if (y == nil) then
                    y = 0
                end
                pspeed = _util.vlen2(x, y)
            end
            local czspeed = nil
            if (_context.cvelocity ~= nil) then
                local z = _context.cvelocity[3]
                if (z == nil) then
                    z = 0
                end
                czspeed = z
            end
            local pzspeed = nil
            if (_context.pvelocity ~= nil) then
                local z = _context.pvelocity[3]
                if (z == nil) then
                    z = 0
                end
                pzspeed = z
            end
            if (cspeed ~= nil and pspeed ~= nil and czspeed ~= nil and pzspeed ~= nil) then
                local dspeed = cspeed - pspeed
                if (_context.cladder > 0) then
                    dspeed = math.abs(czspeed) - math.abs(pzspeed)
                end
                if (dspeed > 0) then
                    if (((_ui.speed_ladder_checkbox:GetValue() and _context.cladder > 0) and math.abs(czspeed) or cspeed) >= (_context.cladder > 0 and _ui.speed_far_ladder_slider:GetValue() or _ui.speed_far_slider:GetValue())) then
                        _context.speed_color = {_ui.speed_far_color:GetValue()}
                    elseif ((not _ui.speed_neutral_color_disable_in_air_checkbox:GetValue() and _context.cground < 0 or _context.cground > _ui.speed_neutral_color_ticks_slider:GetValue()) and math.abs(dspeed) <= _ui.speed_neutral_color_delta_error_slider:GetValue()) then
                        _context.speed_color = {_ui.speed_neutral_color:GetValue()}
                    elseif (dspeed > 0) then
                        _context.speed_color = {_ui.speed_positive_color:GetValue()}
                    end
                elseif ((not _ui.speed_negative_color_disable_on_ground_checkbox:GetValue() and (_context.cground > 0) or (_context.cground < 0)) and not _util.in_range(math.abs(_context.cground), 0, _ui.speed_negative_color_ticks_slider:GetValue()) and dspeed < -_ui.speed_negative_color_delta_error_slider:GetValue()) then
                    _context.speed_color = {_ui.speed_negative_color:GetValue()}
                end
            end
        end
    end

    do
        local ui_font_name = _ui.global_font_name_combobox
        local ui_font_size = _ui.global_font_size_slider
        local ui_font_weight = _ui.global_font_weight_slider
        if (_ui.speed_font_checkbox:GetValue()) then
            ui_font_name = _ui.speed_font_name_combobox
            ui_font_size = _ui.speed_font_size_slider
            ui_font_weight = _ui.speed_font_weight_slider
        end
        _context.speed_font = _util.fnext(_font, _ui.font.keys[ui_font_name:GetValue() + 1], ui_font_size:GetValue(), ui_font_weight:GetValue())
    end

    do
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
    end
end)

_g.callbacks.Register(_call.pre_move, function()
    if (_client.plr and _client.plr:IsAlive()) then
        _context.pre_flags = _client.plr:GetPropInt(_prop.flags)
        _context.pre_duck = bit.band(_context.pre_flags, _flag.ducking) == _flag.ducking
    else
        _context.pre_flags = nil
        _context.pre_duck = nil
    end
end)

_g.callbacks.Register(_call.draw, function()
    _context.screen_w, _context.screen_h = _g.draw.GetScreenSize()

    if (_g.engine.GetServerIP() == nil or _g.engine.GetMapName() == nil) then
        return
    end

    if (_client.plr and _ui.speed_checkbox:GetValue() and _context.speed_font and _context.speed_color ~= nil and _context.screen_w ~= nil and _context.screen_h ~= nil) then
        local scope = _client.plr:GetPropBool(_prop.scope)
        if (not _ui.speed_hide_checkbox:GetValue() or (scope ~= nil and not scope)) then
            local x = _context.cvelocity[1]
            if (x == nil) then
                x = 0
            end
            local y = _context.cvelocity[2]
            if (y == nil) then
                y = 0
            end
            local z = _context.cvelocity[3]
            if (z == nil) then
                z = 0
            end
            local speed = 0
            if (_ui.speed_ladder_checkbox:GetValue() and _context.cladder > 0 and _context.cground < 0 and _context.clag < 0) then
                speed = math.abs(z)
            else
                if (not _ui.speed_x_checkbox:GetValue()) then
                    x = 0
                end
                if (not _ui.speed_y_checkbox:GetValue()) then
                    y = 0
                end
                if (not _ui.speed_z_checkbox:GetValue()) then
                    z = 0
                end
                speed = _util.vlen3(x, y, z)
            end
            local accuracy = _ui.speed_accuracy_slider:GetValue()
            local zeros = _ui.speed_zeros_slider:GetValue()
            if (accuracy ~= 0) then
                zeros = zeros + accuracy + 1
            end

            _g.draw.SetFont(_context.speed_font)

            local text = string.format("%0" .. tostring(zeros) .. "." .. tostring(accuracy) .. "f", speed)
            local text_w, text_h = _g.draw.GetTextSize(text)
            local text_x, text_y = _context.screen_w * _ui.speed_pos_x_slider:GetValue() - text_w / 2, _context.screen_h * (1 - _ui.speed_pos_y_slider:GetValue()) - text_h / 2

            if (_context.speed_shadow_offset_x ~= nil and _context.speed_shadow_offset_y ~= nil and _context.speed_shadow_color ~= nil) then
                local shd_x, shd_y = text_x + _context.speed_shadow_offset_x, text_y + _context.speed_shadow_offset_y
                _g.draw.Color(unpack(_context.speed_shadow_color))
                _g.draw.Text(shd_x, shd_y, text)
            end

            _g.draw.Color(unpack(_context.speed_color))
            _g.draw.Text(text_x, text_y, text)
        end
    end

    if (_ui.debug_checkbox:GetValue()) then
        _g.draw.SetFont(_dbg.font)

        if (_ui.debug_specs_checkbox:GetValue() and _context.spectators ~= nil) then
            local space_w, space_h = _g.draw.GetTextSize(" ")
            local curr_x, curr_y = space_w, space_h
            for _, entity in ipairs(_context.spectators) do
                local text = entity:GetName()

                _g.draw.Color(0, 0, 0, 255)
                _g.draw.Text(curr_x + 1, curr_y + 1, text)

                _g.draw.Color(_ui.debug_color:GetValue())
                _g.draw.Text(curr_x, curr_y, text)

                local text_w, text_h = _g.draw.GetTextSize(text)
                curr_y = curr_y + text_h + space_h
            end
        end

        if (_ui.debug_jt_checkbox:GetValue()) then
            local space_w, space_h = _g.draw.GetTextSize(" ")
            local text = _jt.names[_context.jt]
            local text_w, text_h = _g.draw.GetTextSize(text)
            local text_x, text_y = _context.screen_w - text_w - space_w, space_h

            _g.draw.Color(0, 0, 0, 255)
            _g.draw.Text(text_x + 1, text_y + 1, text)

            _g.draw.Color(_ui.debug_color:GetValue())
            _g.draw.Text(text_x, text_y, text)
        end
    end
end)

_g.callbacks.Register(_call.unload, function()
    _g.client.SetConVar(_cv.spread, _def.spread, true)
    _g.client.SetConVar(_cv.sway, _def.sway, true)
end)
