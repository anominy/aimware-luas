local _g = {}
_g.gui = gui
_g.client = client
_g.callbacks = callbacks
_g.entities = entities

local _ref = {}
_ref.menu = _g.gui.Reference("Menu")
_ref.settings = _g.gui.Reference("Settings")

local _tab = {}
_tab.laj = _g.gui.Tab(_ref.settings, "settings.laj", "LadderJump")

local _ui = {}
_ui.laj_checkbox = _g.gui.Checkbox(_tab.laj, "enable.checkbox", "Enable", true)
_ui.laj_checkbox:SetDescription("Release +forward or +back at start of a ladder jump.")

_ui.laj_ground_checkbox = _g.gui.Checkbox(_tab.laj, "ground.checkbox", "On Ground", false)
_ui.laj_ground_checkbox:SetDescription("Release +forward or +back at start of a ladder walk-off.")

_ui.laj_alias_fw_editbox = _g.gui.Editbox(_tab.laj, "alias.fw.editbox", "Forward Alias")
_ui.laj_alias_fw_editbox:SetDescription("Set custom forawrd alias that will be executed at start of a ladder jump.")

_ui.laj_alias_bw_editbox = _g.gui.Editbox(_tab.laj, "alias.bw.editbox", "Back Alias")
_ui.laj_alias_bw_editbox:SetDescription("Set custom back alias that will be executed at statrt of a ladder jump.")

local _def = {}
_def.fw_alias = "-forward"
_def.bw_alias = "-back"

local _prop = {}
_prop.obs_target = "m_hObserverTarget"
_prop.render_mode = "m_nRenderMode"
_prop.flags = "m_fFlags"

local _render = {}
_render.ladder = 2304

local _flag = {}
_flag.on_ground = 1

local _call = {}
_call.move = "CreateMove"

local _client = {}
_client.lcl = nil
_client.plr = nil
_client.trg = nil

local _context = {}
_context.ground = 0
_context.cladder = 0
_context.pladder = 0

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

    if (_ui.laj_checkbox:GetValue() and _client.lcl and _client.lcl:IsAlive()) then
        if ((_context.cladder ~= nil and _context.cladder < 0) and (_context.pladder ~= nil and _context.pladder > 0) and (_ui.laj_ground_checkbox:GetValue() or (_context.ground ~= nil and _context.ground < 0))) then
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
end)
