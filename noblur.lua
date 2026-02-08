local _g = {}
_g.callbacks = callbacks
_g.client = client

local _def = {}
_def.blur = 0

local _cv = {}
_cv.blur = "@panorama_disable_blur"

local _call = {}
_call.move = "CreateMove"
_call.unload = "Unload"

_g.callbacks.Register(_call.move, function()
    if (tonumber(_g.client.GetConVar(_cv.blur)) == _def.blur) then
        _g.client.SetConVar(_cv.blur, 1, true)
    end
end)

_g.callbacks.Register(_call.unload, function()
    _g.client.SetConVar(_cv.blur, _def.blur, true)
end)
