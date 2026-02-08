local _g = {}
_g.gui = gui
_g.callbacks = callbacks
_g.client = client

local _ref = {}
_ref.menu = _g.gui.Reference("Menu")
_ref.settings = _g.gui.Reference("Settings")

local _tab = {}
_tab.sway = _g.gui.Tab(_ref.settings, "settings.sway", "Sway")

local _ui = {}
_ui.sway_checkbox = _g.gui.Checkbox(_tab.sway, "enable.checkbox", "Enable", false)
_ui.sway_checkbox:SetDescription("Override the `cl_wpn_sway_scale` console variable.")

_ui.sway_scale_slider = _g.gui.Slider(_tab.sway, "scale.slider", "Scale", 0, 0, 1.6, 0.01)
_ui.sway_scale_slider:SetDescription("Set value of the `cl_wpn_sway_scale` console variable.")

local _def = {}
_def.sway = 1.6

local _cv = {}
_cv.sway = "cl_wpn_sway_scale"

local _call = {}
_call.move = "CreateMove"
_call.unload = "Unload"

_g.callbacks.Register(_call.move, function()
    if (_ui.sway_checkbox:GetValue()) then
        _g.client.SetConVar(_cv.sway, _ui.sway_scale_slider:GetValue(), true)
    elseif (tonumber(_g.client.GetConVar(_cv.sway)) ~= _def.sway) then
        _g.client.SetConVar(_cv.sway, _def.sway, true)
    end
end)

_g.callbacks.Register(_call.unload, function()
    _g.client.SetConVar(_cv.sway, _def.sway, true)
end)
