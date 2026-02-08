local _util = {}
_util.in_range = function(v, a, b)
    if (v == nil or a == nil or b == nil) then
        return nil
    end
    v = tonumber(v)
    a = tonumber(a)
    b = tonumber(b)
    return (v >= a and v <= b)
end

local _g = {}
_g.gui = gui
_g.callbacks = callbacks
_g.client = client
_g.entities = entities
_g.input = input

local _ref = {}
_ref.menu = _g.gui.Reference("Menu")
_ref.settings = _g.gui.Reference("Settings")

local _tab = {}
_tab.movement = _g.gui.Tab(_ref.settings, "settings.movement", "Movement")

local _ui = {}
_ui.spread_checkbox = _g.gui.Checkbox(_tab.movement, "spread.show.checkbox", "Spread", true)
_ui.spread_checkbox:SetDescription("Show weapon spread using the `weapon_debug_spread_show` console variable.")

_ui.spread_hide_checkbox = _g.gui.Checkbox(_tab.movement, "spread.hide.checkbox", "Spread Hide", false)
_ui.spread_hide_checkbox:SetDescription("Hide weapon spread while scroping using the `weapon_debug_spread_show` console variable.")

_ui.spread_start_slider = _g.gui.Slider(_tab.movement, "spread.start.slider", "Spread Start", 0.01, 0, 1, 0.005)
_ui.spread_start_slider:SetDescription("Innacuracy value of current weapon from which to start showing the weapon spread.")

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

local _def = {}
_def.spread = 0
_def.fw_alias = "-forward"
_def.bw_alias = "-back"
_def.rt_alias = "-moveright"
_def.lt_alias = "-moveleft"

local _cv = {}
_cv.spread = "weapon_debug_spread_show"
_cv.cross_style = "cl_crosshairstyle"

local _prop = {}
_prop.obs_target = "m_hObserverTarget"
_prop.scope = "m_bIsScoped"
_prop.flags = "m_fFlags"

local _flag = {}
_flag.on_ground = 1

local _button = {}
_button.in_jump = 2

local _call = {}
_call.move = "CreateMove"
_call.unload = "Unload"

local _client = {}
_client.lcl = nil
_client.plr = nil
_client.trg = nil

local _context = {}
_context.pground = 0
_context.cground = 0

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

    if (_client.lcl and _client.lcl:IsAlive() and bit.band(cmd.buttons, _button.in_jump) == _button.in_jump) then
        if ((_context.cground == -1) and (_ui.lj_checkbox:GetValue() and _g.input.GetMouseWheelDelta() == 0 and (_context.pground > _ui.lj_ticks_slider:GetValue()) or _ui.lj_scroll_checkbox:GetValue() and _g.input.GetMouseWheelDelta() ~= 0 and (_context.pground >= _ui.lj_scroll_ticks_slider:GetValue()))) then
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
end)

_g.callbacks.Register(_call.unload, function()
    _g.client.SetConVar(_cv.spread, _def.spread, true)
end)
