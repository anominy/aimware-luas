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

_util.vlen3 = function(x, y, z)
    x = tonumber(x)
    y = tonumber(y)
    z = tonumber(z)
    return math.sqrt(x^2 + y^2 + z^2)
end

_util.vlen2 = function(x, y)
    return _util.vlen3(x, y, 0)
end

local _g = {}
_g.gui = gui
_g.callbacks = callbacks
_g.client = client
_g.entities = entities
_g.input = input
_g.draw = draw
_g.engine = engine

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

_ui.debug_checkbox = _g.gui.Checkbox(_tab.movement, "debug.checkbox", "Debug", false)
_ui.debug_checkbox:SetDescription("Show debug text on the screen.")

_ui.debug_color = _g.gui.ColorPicker(_tab.movement, "debug.color", "Debug Color", 0, 255, 0, 255)

_ui.debug_specs_checkbox = _g.gui.Checkbox(_tab.movement, "debug.specs.checkbox", "Debug Spectators", false)
_ui.debug_specs_checkbox:SetDescription("Show list of spectators on the left top corner of the screen.")

_ui.debug_specs_self_checkbox = _g.gui.Checkbox(_tab.movement, "debug.specs.self.checkbox", "Debug Spectators Self", false)
_ui.debug_specs_self_checkbox:SetDescription("Show yourself on the list of spectators on the left top corner of the screen.")

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
_render.ladder = 2304

local _flag = {}
_flag.on_ground = 1

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

local _context = {}
_context.screen_w = nil
_context.screen_h = nil
_context.jb_button = 0
_context.pre_flags = nil
_context.pground = 0
_context.cground = 0
_context.pladder = 0
_context.cladder = 0
_context.speed = nil
_context.spectators = nil

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

        local render_mode = _client.plr:GetPropInt(_prop.render_mode)
        _context.pladder = _context.cladder
        if (render_mode ~= nil) then
            if (render_mode == _render.ladder) then
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
        local vel_x = _client.plr:GetPropFloat("localdata", _prop.vel_x)
        if (vel_x == nil) then
            vel_x = 0
        end
        local vel_y = _client.plr:GetPropFloat("localdata", _prop.vel_y)
        if (vel_y == nil) then
            vel_y = 0
        end
        _context.speed = _util.vlen2(vel_x, vel_y)

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
end)

_g.callbacks.Register(_call.pre_move, function()
    if (_client.lcl and _client.lcl:IsAlive()) then
        _context.pre_flags = _client.lcl:GetPropInt(_prop.flags)
    end
end)

_g.callbacks.Register(_call.draw, function()
    _context.screen_w, _context.screen_h = _g.draw.GetScreenSize()

    if (_g.engine.GetServerIP() == nil or _g.engine.GetMapName() == nil) then
        return
    end

    if (_ui.debug_checkbox:GetValue() and _context.screen_w ~= nil and _context.screen_h ~= nil and _context.speed ~= nil) then
        local color = {_ui.debug_color:GetValue()}

        _g.draw.SetFont(_dbg.font)

        local text = string.format("%03.0f", _context.speed)
        local text_w, text_h = _g.draw.GetTextSize(text)
        local text_x, text_y = _context.screen_w * 0.5 - text_w / 2, _context.screen_h * 0.6 - text_h / 2

        _g.draw.Color(0, 0, 0, 255)
        _g.draw.Text(text_x + 1, text_y + 1, text)

        _g.draw.Color(unpack(color))
        _g.draw.Text(text_x, text_y, text)

        if (_ui.debug_specs_checkbox:GetValue() and _context.spectators ~= nil) then
            local space_w, space_h = _g.draw.GetTextSize(" ")
            local curr_x, curr_y = space_w, space_h
            for _, entity in ipairs(_context.spectators) do
                local text = entity:GetName()

                _g.draw.Color(0, 0, 0, 255)
                _g.draw.Text(curr_x + 1, curr_y + 1, text)

                _g.draw.Color(unpack(color))
                _g.draw.Text(curr_x, curr_y, text)

                local text_w, text_h = _g.draw.GetTextSize(text)
                curr_y = curr_y + text_h + space_h
            end
        end
    end
end)

_g.callbacks.Register(_call.unload, function()
    _g.client.SetConVar(_cv.spread, _def.spread, true)
    _g.client.SetConVar(_cv.sway, _def.sway, true)
end)
