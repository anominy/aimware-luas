local _g = {}
_g.gui = gui
_g.callbacks = callbacks
_g.client = client

local _ref = {}
_ref.menu = _g.gui.Reference("Menu")
_ref.settings = _g.gui.Reference("Settings")

local _tab = {}
_tab.panorama = _g.gui.Tab(_ref.settings, "settings.panorama", "Panorama")

local _ui = {}
_ui.blur_checkbox = _g.gui.Checkbox(_tab.panorama, "blur.checkbox", "Blur", true)
_ui.blur_checkbox:SetDescription("Switch the blur of the panorama interface using the `@panorama_disable_blur` console variable.")

local _def = {}
_def.blur = 0

local _cv = {}
_cv.blur = "@panorama_disable_blur"

local _call = {}
_call.move = "CreateMove"
_call.unload = "Unload"

_g.callbacks.Register(_call.move, function()
    if (not _ui.blur_checkbox:GetValue()) then
        _g.client.SetConVar(_cv.blur, 1, true)
    elseif (tonumber(_g.client.GetConVar(_cv.blur)) ~= _def.blur) then
        _g.client.SetConVar(_cv.blur, _def.blur, true)
    end
end)

_g.callbacks.Register(_call.unload, function()
    _g.client.SetConVar(_cv.blur, _def.blur, true)
end)
