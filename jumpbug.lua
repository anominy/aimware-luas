local _g = {}
_g.gui = gui
_g.callbacks = callbacks
_g.entities = entities
_g.input = input

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

local _jbt = {}
_jbt.standard = 1
_jbt.improved = 2

local _ref = {}
_ref.menu = _g.gui.Reference("Menu")
_ref.settings = _g.gui.Reference("Settings")

local _tab = {}
_tab.jb = _g.gui.Tab(_ref.settings, "settings.jb", "Jump-Bug")

local _ui = {}
_ui.jbt = _util.init_table({"Standard", "Improved"}, {_jbt.standard, _jbt.improved})

_ui.jb_checkbox = _g.gui.Checkbox(_tab.jb, "enable.checkbox", "Eanble", true)
_ui.jb_checkbox:SetDescription("Disable the auto jump-bug on the ground and enable it in the air.")

_ui.jb_auto_jump_checkbox = _g.gui.Checkbox(_tab.jb, "auto_jump.checkbox", "Auto Jump", true)
_ui.jb_auto_jump_checkbox:SetDescription("Switch the jump-bug's auto jump, if disabled, it will supress the auto jump after a failed jump-bug.")

_ui.jb_type_combobox = _g.gui.Combobox(_tab.jb, "type.combobox", "Type", unpack(_ui.jbt.keys))
_ui.jb_type_combobox:SetDescription("Switch an implementation of the auto jump-bug feature.")

_ui.jb_lag_checkbox = _g.gui.Checkbox(_tab.jb, "lag.checkbox", "Ladder Glide", true)
_ui.jb_lag_checkbox:SetDescription("Set in-jump button when holding the jump-bug key while ladder moving.")

local _var = {}
_var.jb = "misc.autojumpbug"

local _prop = {}
_prop.obs_target = "m_hObserverTarget"
_prop.flags = "m_fFlags"
_prop.render_mode = "m_nRenderMode"

local _flag = {}
_flag.on_ground = 1

local _render = {}
_render.ladder = 2304

local _button = {}
_button.in_jump = 2
_button.in_duck = 4

local _call = {}
_call.move = "CreateMove"
_call.pre_move = "PreMove"

local _client = {}
_client.lcl = nil
_client.plr = nil
_client.trg = nil

local _context = {}
_context.jb_button = 0
_context.pre_flags = nil
_context.ground = 0
_context.ladder = 0

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

    if (_client.lcl and _client.lcl:IsAlive()) then
        local flags = _client.lcl:GetPropInt(_prop.flags)
        if (flags ~= nil) then
            if (bit.band(flags, _flag.on_ground) == _flag.on_ground) then
                if (_context.ground < 0) then
                    _context.ground = 0
                end
                _context.ground = _context.ground + 1
            else
                if (_context.ground > 0) then
                    _context.ground = 0
                end
                _context.ground = _context.ground - 1
            end
        else
            _context.ground = 0
        end

        local render_mode = _client.lcl:GetPropInt(_prop.render_mode)
        if (render_mode ~= nil) then
            if (render_mode == _render.ladder) then
                if (_context.ladder < 0) then
                    _context.ladder = 0
                end
                _context.ladder = _context.ladder + 1
            else
                if (_context.ladder > 0) then
                    _context.ladder = 0
                end
                _context.ladder = _context.ladder - 1
            end
        else
            _context.ladder = 0
        end
    end

    if (_ui.jb_checkbox:GetValue()) then
        local jb_button = _g.gui.GetValue(_var.jb)
        if (not _ref.menu:IsActive()) then
            if (_client.lcl and _client.lcl:IsAlive()) then
                local jb_type = _ui.jbt[_ui.jbt.keys[_ui.jb_type_combobox:GetValue() + 1]]
                if (jb_type == _jbt.standard) then
                    if ((_context.ground ~= nil and _context.ground > (_ui.jb_auto_jump_checkbox:GetValue() and 1 or 0)) or (_context.ladder ~= nil and _context.ladder > 0)) then
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
                        if ((_context.pre_flags ~= nil and bit.band(_context.pre_flags, _flag.on_ground) ~= _flag.on_ground) and (_context.ground ~= nil and _context.ground > 0)) then
                            cmd.buttons = bit.bor(cmd.buttons, _button.in_duck)
                        end
                    end
                end
                if (_ui.jb_lag_checkbox:GetValue() and (_context.ladder ~= nil and _context.ladder > 0) and _context.jb_button ~= 0 and _g.input.IsButtonDown(_context.jb_button)) then
                    cmd.buttons = bit.bor(cmd.buttons, _button.in_jump)
                end
            elseif (jb_button == 0 and _context.jb_button ~= 0) then
                _g.gui.SetValue(_var.jb, _context.jb_button)
            end
        elseif (jb_button == 0 and _context.jb_button ~= 0) then
            _g.gui.SetValue(_var.jb, _context.jb_button)
        end
    end
end)

_g.callbacks.Register(_call.pre_move, function()
    if (_client.lcl and _client.lcl:IsAlive()) then
        _context.pre_flags = _client.lcl:GetPropInt(_prop.flags)
    end
end)
