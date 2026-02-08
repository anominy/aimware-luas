local _g = {}
_g.gui = gui
_g.callbacks = callbacks
_g.client = client
_g.entities = entities

local _ref = {}
_ref.menu = _g.gui.Reference("Menu")
_ref.settings = _g.gui.Reference("Settings")

local _tab = {}
_tab.spread = _g.gui.Tab(_ref.settings, "settings.spread", "Spread")

local _ui = {}
_ui.spread_checkbox = _g.gui.Checkbox(_tab.spread, "show.checkbox", "Show", true)
_ui.spread_checkbox:SetDescription("Show weapon spread using the `weapon_debug_spread_show` console variable.")

_ui.spread_hide_checkbox = _g.gui.Checkbox(_tab.spread, "hide.checkbox", "Hide", false)
_ui.spread_hide_checkbox:SetDescription("Hide weapon spread while scroping using the `weapon_debug_spread_show` console variable.")

_ui.spread_start_slider = _g.gui.Slider(_tab.spread, "start.slider", "Start", 0.01, 0, 1, 0.005)
_ui.spread_start_slider:SetDescription("Innacuracy value of current weapon from which to start showing the weapon spread.")

local _def = {}
_def.spread = 0

local _cv = {}
_cv.spread = "weapon_debug_spread_show"
_cv.cross_style = "cl_crosshairstyle"

local _prop = {}
_prop.obs_target = "m_hObserverTarget"
_prop.scope = "m_bIsScoped"

local _call = {}
_call.move = "CreateMove"
_call.unload = "Unload"

local _client = {}
_client.lcl = nil
_client.plr = nil
_client.trg = nil

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

_g.callbacks.Register(_call.move, function()
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
end)

_g.callbacks.Register(_call.unload, function()
    _g.client.SetConVar(_cv.spread, _def.spread, true)
end)
