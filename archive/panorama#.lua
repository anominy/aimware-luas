local default = {}
default.blur = 0

local convar = {}
convar.blur = "@panorama_disable_blur"

local ref = {}
ref.settings = gui.Reference("Settings")

local tab = {}
tab.panorama = gui.Tab(ref.settings, "settings.panorama", "Panorama")

local ui = {}
ui.blur_checkbox = gui.Checkbox(tab.panorama, "blur.checkbox", "Blur", true)
ui.blur_checkbox:SetDescription("Switch the blur of the panorama interface using the `@panorama_disable_blur` console variable.")

callbacks.Register("CreateMove", function()
    if (not ui.blur_checkbox:GetValue()) then
        client.SetConVar(convar.blur, 1)
    elseif (tonumber(client.GetConVar(convar.blur)) ~= default.blur) then
        client.SetConVar(convar.blur, default.blur)
    end
end)
