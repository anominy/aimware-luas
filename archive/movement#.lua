
_ui.jb_checkbox = gui.Checkbox(_tab.movement, "jb.checkbox", "Jump-Bug", false)
_ui.jb_checkbox:SetDescription("Disable the auto jump-bug on the ground and enable it in the air.")

_ui.jb_auto_jump_checkbox = gui.Checkbox(_tab.movement, "jb.auto_jump.checkbox", "Jump-Bug Auto Jump", true)
_ui.jb_auto_jump_checkbox:SetDescription("Switch the jump-bug's auto jump, if disabled, it will suppress the auto jump after a failed jump-bug.")

_ui.jb_lag_checkbox = gui.Checkbox(_tab.movement, "jb.lag.checkbox", "Jump-Bug Ladder Glide", true)
_ui.jb_lag_checkbox:SetDescription("Set in-jump button when holding the jump-bug key while ladder moving.")

_ui.laj_checkbox = gui.Checkbox(_tab.movement, "laj.checkbox", "Ladder Jump", false)
_ui.laj_checkbox:SetDescription("Release +forward or +back when doing a ladder jump.")

_ui.laj_ground_checkbox = gui.Checkbox(_tab.movement, "laj.ground.checkbox", "Ladder Jump On Ground", false)
_ui.laj_ground_checkbox:SetDescription("Release +forward or +back when walking-off from a ladder.")

_ui.laj_alias_fw_editbox = gui.Editbox(_tab.movement, "laj.alias.fw.editbox", "Ladder Jump Custom Forward Alias")
_ui.laj_alias_fw_editbox:SetDescription("Set custom forward alias that will be executed after a ladder jump.")

_ui.laj_alias_bw_editbox = gui.Editbox(_tab.movement, "laj.alias.bw.editbox", "Ladder Jump Custom Back Alias")
_ui.laj_alias_bw_editbox:SetDescription("Set custom back alias that will be release for a ladder jump.")

_ui.ej_checkbox = gui.Checkbox(_tab.movement, "ej.checkbox", "Edge Jump", false)
_ui.ej_checkbox:SetDescription("Release +forward or +back or +moveright or +moveleft when doing an edge jump.")

_ui.ej_alias_fw_editbox = gui.Editbox(_tab.movement, "ej.alias.fw.editbox", "Edge Jump Custom Forward Alias")
_ui.ej_alias_fw_editbox:SetDescription("Set custom forward alias that will be executed after an edge jump.")

_ui.ej_alias_bw_editbox = gui.Editbox(_tab.movement, "ej.alias.bw.editbox", "Edge Jump Custom Back Alias")
_ui.ej_alias_bw_editbox:SetDescription("Set custom back alias that will be executed after an edge jump.")

_ui.ej_alias_right_editbox = gui.Editbox(_tab.movement, "ej.alias.right.editbox", "Edge Jump Custom Right Alias")
_ui.ej_alias_right_editbox:SetDescription("Set custom right alias that will be executed after an edge jump.")

_ui.ej_alias_left_editbox = gui.Editbox(_tab.movement, "ej.alias.left.editbox", "Edge Jump Custom Left Alias")
_ui.ej_alias_left_editbox:SetDescription("Set custom left alias the will be executed after an edge jump.")

_ui.lj_checkbox = gui.Checkbox(_tab.movement, "lj.checkbox", "Long Jump", false)
_ui.lj_checkbox:SetDescription("Release +forawrd or +back or +moveright or +moveleft when doing a long jump.")

_ui.lj_ticks_slider = gui.Slider(_tab.movement, "lj.ticks.slider", "Long Jump Ticks", 2, 2, 64)
_ui.lj_ticks_slider:SetDescription("Set how many ticks on the ground needed before doing a long jump.")

_ui.lj_scroll_checkbox = gui.Checkbox(_tab.movement, "lj.scroll.checkbox", "Long Jump Scroll", false)
_ui.lj_scroll_checkbox:SetDescription("Release +forawrd or +back or +moveright or +moveleft when doing a scroll long jump.")

_ui.lj_scroll_ticks_slider = gui.Slider(_tab.movement, "lj.scroll.ticks.slider", "Long Jump Scroll Ticks", 8, 2, 64)
_ui.lj_scroll_ticks_slider:SetDescription("Set how many ticks on the ground needed before doing a scroll long jump.")

_ui.lj_alias_fw_editbox = gui.Editbox(_tab.movement, "lj.alias.fw.editbox", "Long Jump Custom Forward Alias")
_ui.lj_alias_fw_editbox:SetDescription("Set custom forawrd alias that will be executed after a long jump.")

_ui.lj_alias_bw_editbox = gui.Editbox(_tab.movement, "lj.alias.bw.editbox", "Long Jump Custom Back Alias")
_ui.lj_alias_bw_editbox:SetDescription("Set custom back alias that will be executed after a long jump.")

_ui.lj_alias_right_editbox = gui.Editbox(_tab.movement, "lj.alias.right.editbox", "Long Jump Custom Right Alias")
_ui.lj_alias_right_editbox:SetDescription("Set custom right alias that will be executed after a long jump.")

_ui.lj_alias_left_editbox = gui.Editbox(_tab.movement, "lj.alias.left.editbox", "Long Jump Custom Left Alias")
_ui.lj_alias_left_editbox:SetDescription("Set custom left alias that will be executed after a long jump.")

_ui.spread_checkbox = gui.Checkbox(_tab.movement, "spread.checkbox", "Spread", false)
_ui.spread_checkbox:SetDescription("Show weapon spread using `weapon_debug_spread_show` console variable.")

_ui.spread_hide_checkbox = gui.Checkbox(_tab.movement, "spread.hide.checkbox", "Spread Hide", false)
_ui.spread_hide_checkbox:SetDescription("Hide weapon spread while scoping using `weapon_debug_spread_show` console variable.")

_ui.spread_start_slider =  gui.Slider(_tab.movement, "spread.start.slider", "Spread Start", 0.01, 0, 1, 0.005)
_ui.spread_start_slider:SetDescription("Inaccuracy value of current weapon from which start to show the weapon spread.")

_ui.weapon_sway_checkbox = gui.Checkbox(_tab.movement, "weapon.sway.checkbox", "Weapon Sway", false)
_ui.weapon_sway_checkbox:SetDescription("Override the `cl_wpn_sway_scale` console variable.")

_ui.weapon_sway_scale_slider = gui.Slider(_tab.movement, "weapon.sway.scale.slider", "Weapon Sway Scale", 0, 0, 1.6, 0.01)
_ui.weapon_sway_scale_slider:SetDescription("Set value of `cl_wpn_sway_scale` console variable.")

_ui.velocity_checkbox = gui.Checkbox(_tab.movement, "velocity.checkbox", "Speed", false)
_ui.velocity_checkbox:SetDescription("Show local & spec-target speed on the screen.")

_ui.velocity_hide_checkbox = gui.Checkbox(_tab.movement, "velocity.hide.checkbox", "Speed Hide", true)
_ui.velocity_hide_checkbox:SetDescription("Hide local & spec-target speed while scoping.")

_ui.velocity_ladder_checkbox = gui.Checkbox(_tab.movement, "velocity.ladder.checkbox", "Speed Ladder", false)
_ui.velocity_ladder_checkbox:SetDescription("Show local & spec-target vertical speed while ladder moving.")

_ui.velocity_font_name_combobox = gui.Combobox(_tab.movement, "velocity.font.name.combobox", "Speed Font Name", unpack(_ui.font.keys))
_ui.velocity_font_name_combobox:SetDescription("Set local & spect-target speed font name.")

_ui.velocity_font_size_slider = gui.Slider(_tab.movement, "velocity.font.size.slider", "Speed Font Size", 20, 0, 64)
_ui.velocity_font_size_slider:SetDescription("Set local & spec-target speed font size.")

_ui.velocity_font_weight_slider = gui.Slider(_tab.movement, "font.weight.slider", "Speed Font Weight", 900, 0, 1000, 100)
_ui.velocity_font_weight_slider:SetDescription("Set local & spec-target speed font weight.")

_ui.velocity_x_checkbox = gui.Checkbox(_tab.movement, "velocity.x.checkbox", "Speed by X-Axis", true)
_ui.velocity_x_checkbox:SetDescription("Use local & spec-target x-axis speed for accumulating.")

_ui.velocity_y_checkbox = gui.Checkbox(_tab.movement, "velocity.y.checkbox", "Speed by Y-Axis", true)
_ui.velocity_y_checkbox:SetDescription("Use local & spec-target y-axis speed for accumulating.")

_ui.velocity_z_checkbox = gui.Checkbox(_tab.movement, "velocity.z.checkbox", "Speed by Z-Axis", false)
_ui.velocity_z_checkbox:SetDescription("Use local & spec-target z-axis speed for accumulating.")

_ui.velocity_position_x_slider = gui.Slider(_tab.movement, "velocity.position.x.slider", "Speed X-Axis Position", 50, 0, 100)
_ui.velocity_position_x_slider:SetDescription("Set local & spec-target speed position on the x-axis in percentage.")

_ui.velocity_position_y_slider = gui.Slider(_tab.movement, "velocity.position.y.slider", "Speed Y-Axis Position", 40, 0, 100)
_ui.velocity_position_y_slider:SetDescription("Set local & spec-target speed position on the y-axis in percentage.")

_ui.velocity_accuracy_slider = gui.Slider(_tab.movement, "velocity.accuracy.slider", "Speed Accuracy", 0, 0, 3)
_ui.velocity_accuracy_slider:SetDescription("Set local & spec-target speed accuracy which represents number of digits after the dot.")

_ui.velocity_latency_slider = gui.Slider(_tab.movement, "velocity.latency.slider", "Speed Latency", 0, 0, 1, 0.01)
_ui.velocity_latency_slider:SetDescription("Set local & spec-target speed draw update rate which represents how long it takes to render the value.")

_ui.velocity_brackets_combobox = gui.Combobox(_tab.movement, "velocity.brackets.combobox", "Speed Brackets", unpack(_ui.bracket.keys))
_ui.velocity_brackets_combobox:SetDescription("Set brackets that reside around the speed value.")

_ui.velocity_takeoff_checkbox = gui.Checkbox(_tab.movement, "velocity.takeoff.checkbox", "Speed Takeoff", false)
_ui.velocity_takeoff_checkbox:SetDescription("Show local & spec-target takeoff speed on the screen.")

_ui.velocity_takeoff_time_slider = gui.Slider(_tab.movement, "velocity.takeoff.time.slider", "Speed Takeoff Time", 0, 0, 1, 0.01)
_ui.velocity_takeoff_time_slider:SetDescription("Set time in seconds needed to reset the takeoff speed value.")

_ui.velocity_takeoff_ignore_multibox = gui.Multibox(_tab.movement, "Speed Takeoff Ignore")
_ui.velocity_takeoff_ignore_multibox:SetDescription("Ignore local & spec-target takeoff reset of specified move types.")

_ui.velocity_takeoff_ignore_ladder_checkbox = gui.Checkbox(_ui.velocity_takeoff_ignore_multibox, "velocity.takeoff.ignore.ladder.checkbox", "Ladder", false)
_ui.velocity_takeoff_ignore_ladder_glide_checkbox = gui.Checkbox(_ui.velocity_takeoff_ignore_multibox, "velocity.takeoff.ignore.lag.checkbox", "Ladder Glide", true)

_ui.velocity_takeoff_types_multibox = gui.Multibox(_tab.movement, "Speed Takeoff Types")
_ui.velocity_takeoff_types_multibox:SetDescription("Show local & spect-target specified types of takeoff speed.")

_ui.velocity_takeoff_jump_checkbox = gui.Checkbox(_ui.velocity_takeoff_types_multibox, "velocity.takeoff.jump.checkbox", "Jump", true)
_ui.velocity_takeoff_perfect_checkbox = gui.Checkbox(_ui.velocity_takeoff_types_multibox, "velocity.takeoff.perfect.checkbox", "Perfect", true)
_ui.velocity_takeoff_jb_checkbox = gui.Checkbox(_ui.velocity_takeoff_types_multibox, "velocity.takeoff.jb.checkbox", "Jump-Bug", true)
_ui.velocity_takeoff_laj_checkbox = gui.Checkbox(_ui.velocity_takeoff_types_multibox, "velocity.takeoff.laj.checkbox", "Ladder Jump", true)
_ui.velocity_takeoff_lag_checkbox = gui.Checkbox(_ui.velocity_takeoff_types_multibox, "velocity.takeoff.lag.checkbox", "Ladder Glide", true)
_ui.velocity_takeoff_lah_checkbox = gui.Checkbox(_ui.velocity_takeoff_types_multibox, "velocity.takeoff.lah.checkbox", "Ladder Hop", true)
_ui.velocity_takeoff_ps_checkbox = gui.Checkbox(_ui.velocity_takeoff_types_multibox, "velocity.takeoff.ps.checkbox", "Pixel Surf", true)
_ui.velocity_takeoff_eb_checkbox = gui.Checkbox(_ui.velocity_takeoff_types_multibox, "velocity.takeoff.eb.checkbox", "Edge-Bug", true)
_ui.velocity_takeoff_hh_checkbox = gui.Checkbox(_ui.velocity_takeoff_types_multibox, "velocity.takeoff.hh.checkbox", "Head Hit", true)

_ui.velocity_takeoff_brackets_combobox = gui.Combobox(_tab.movement, "velocity.takeoff.brackets.combobox", "Speed Takeoff Brackets", unpack(_ui.bracket.keys))
_ui.velocity_takeoff_brackets_combobox:SetDescription("Set brackets that reside around the takeoff speed value.")

_ui.velocity_measurement_checkbox = gui.Checkbox(_tab.movement, "velocity.measurement.checkbox", "Speed Measurement", false)
_ui.velocity_measurement_checkbox:SetDescription("Show speed unit-measurement right after the value.")

_ui.velocity_measurement_case_combobox = gui.Combobox(_tab.movement, "velocity.measurement.case.combobox", "Speed Measurement Case", unpack(_ui.case.keys))
_ui.velocity_measurement_case_combobox:SetDescription("Set case of speed unit-measurement that reside right after the value.")

_ui.velocity_measurement_format_combobox = gui.Combobox(_tab.movement, "velocity.measurement.format.combobox", "Speed Measurement Format", unpack(_ui.format.keys))
_ui.velocity_measurement_format_combobox:SetDescription("Set format of speed unit-measurement that reside right after the value.")

_ui.velocity_measurement_separator_combobox = gui.Combobox(_tab.movement, "velocity.measurement.separator.combobox", "Speed Measurement Separator", unpack(_ui.separator.keys))
_ui.velocity_measurement_separator_combobox:SetDescription("Set separator of speed unit-measurement that reside between the value and the measurement text.")

_ui.velcoity_measurement_brackets_combobox = gui.Combobox(_tab.movement, "velocity.measurement.brackets.combobox", "Speed Measurement Brackets", unpack(_ui.bracket.keys))
_ui.velcoity_measurement_brackets_combobox:SetDescription("Set brackets of speed unit-measurement that reside around the measurement text.")

_ui.velocity_shadow_checkbox = gui.Checkbox(_tab.movement, "velocity.shadow.checkbox", "Speed Shadow", true)
_ui.velocity_shadow_checkbox:SetDescription("Show local & spec-target speed shadow on the screen.")

_ui.velocity_shadow_offset_x_slider = gui.Slider(_tab.movement, "velocity.shadow.x.slider", "Speed Shadow X-Axis", 1, -2, 2)
_ui.velocity_shadow_offset_x_slider:SetDescription("Set local & spec-target speed shadow offset on the x-axis.")

_ui.velocity_shadow_offset_y_slider = gui.Slider(_tab.movement, "velocity.shadow.y.slider", "Speed Shadow Y-Axis", 1, -2, 2)
_ui.velocity_shadow_offset_y_slider:SetDescription("Set local & spec-target speed shadow offset on the y-axis.")

_ui.velocity_shadow_color = gui.ColorPicker(_tab.movement, "velocity.shadow.color", "Speed Shadow Color", unpack(_default.vel_shd_color))
_ui.velocity_shadow_color:SetDescription("Set local & spec-target speed shadow color.")

_ui.velocity_alpha_checkbox = gui.Checkbox(_tab.movement, "velocity.alpha.checkbox", "Speed Alpha", false)
_ui.velocity_alpha_checkbox:SetDescription("Change local & spec-target speed alpha channel depending on the current speed.")

_ui.velocity_alpha_weapon_checkbox = gui.Checkbox(_tab.movement, "velocity.alpha.weapon.checkbox", "Speed Weapon Alpha Limit", true)
_ui.velocity_alpha_weapon_checkbox:SetDescription("Use weapon maximum possible speed as the limit which represents how fast alpha channel change.")

_ui.velocity_alpha_limit_slider = gui.Slider(_tab.movement, "velocity.alpha.limit.slider", "Speed Alpha Limit", 200, 0, 286)
_ui.velocity_alpha_limit_slider:SetDescription("Set local & spec-target speed limit which represents how fast alpha channel change.")

_ui.velocity_alpha_ladder_limit_slider = gui.Slider(_tab.movement, "velocity.alpha.ladder.limit.slider", "Speed Alpha Ladder Limit", 280, 0, 312)
_ui.velocity_alpha_ladder_limit_slider:SetDescription("Set local & spec-target speed limit which represents how fast alpha channel change while ladder moving.")

_ui.velocity_alpha_factor_slider = gui.Slider(_tab.movement, "velocity.alpha.factor.slider", "Speed Alpha Factor", 0, 0, 100)
_ui.velocity_alpha_factor_slider:SetDescription("Set local & spec-target speed alpha channel factor which represents the value applicable to the limit.")

_ui.velocity_alpha_offset_slider = gui.Slider(_tab.movement, "velocity.alpha.offset.slider", "Speed Alpha Offset", 0, -100, 100)
_ui.velocity_alpha_offset_slider:SetDescription("Set local & spec-target speed alpha channel offset which represents the value that applicable to the limit.")

_ui.velocity_color_saturation_slider = gui.Slider(_tab.movement, "velocity.color.saturation.slider", "Speed Color Saturation", 1, 0, 1, 0.01)
_ui.velocity_color_saturation_slider:SetDescription("Set local & spec-target speed color saturation.")

_ui.velocity_color_brightness_slider = gui.Slider(_tab.movement, "velocity.color.brightness.slider", "Speed Color Brightness", 1, 0, 1, 0.01)
_ui.velocity_color_brightness_slider:SetDescription("Set local & spec-target speed color brightness.")

_ui.velocity_rainbow_checkbox = gui.Checkbox(_tab.movement, "velocity.rainbow.checkbox", "Speed Rainbow", false)
_ui.velocity_rainbow_checkbox:SetDescription("Set local & spec-target speed color as rainbow.")

_ui.velocity_rainbow_rely_checkbox = gui.Checkbox(_tab.movement, "velocity.rainbow.rely.checkbox", "Speed Rainbow Rely", false)
_ui.velocity_rainbow_rely_checkbox:SetDescription("Set local & spec-target speed color as rainbow of current velocity value.")

_ui.velocity_rainbow_cycle_time_slider = gui.Slider(_tab.movement, "velocity.rainbow.cycle_time.slider", "Speed Rainbow Cycle Time", 4, 0.01, 30, 0.01)
_ui.velocity_rainbow_cycle_time_slider:SetDescription("Set local & spec-target speed color cycle time of rainbow.")

_ui.velocity_rainbow_hue_shift_slider = gui.Slider(_tab.movement, "velocity.rainbow.hue_shift.slider", "Speed Rainbow Hue Shift", 0, 0, 1, 0.01)
_ui.velocity_rainbow_hue_shift_slider:SetDescription("Set local & spec-target speed color hue shift of rainbow.")

_ui.velocity_interp_checkbox = gui.Checkbox(_tab.movement, "velocity.interp.checkbox", "Speed Interpolation", false)
_ui.velocity_interp_checkbox:SetDescription("Set local & spec-target speed color as an interpolation of specified colors.")

_ui.velocity_interp_weapon_limit_checkbox = gui.Checkbox(_tab.movement, "velocity.interp.weapon.checkbox", "Speed Interpolation Weapon Limit", true)
_ui.velocity_interp_weapon_limit_checkbox:SetDescription("Use weapon maximum possible speed as the limit which represents how fast the color change.")

_ui.velocity_interp_limit_slider = gui.Slider(_tab.movement, "velocity.interp.limit.slider", "Speed Interpolation Limit", 250, 0, 286)
_ui.velocity_interp_limit_slider:SetDescription("Set local & spec-target speed limit which represents how fast the color change.")

_ui.velocity_interp_ladder_limit_slider = gui.Slider(_tab.movement, "velocity.interp.ladder.limit.slider", "Speed Interpolation Ladder Limit", 280, 0, 312)
_ui.velocity_interp_ladder_limit_slider:SetDescription("Set local & spec-target speed limit which represents how fast the color change while ladder moving.")

_ui.velocity_interp_factor_slider = gui.Slider(_tab.movement, "velocity.interp.factor.slider", "Speed Interpolation Factor", 0, 0, 100)
_ui.velocity_interp_factor_slider:SetDescription("Set local & spec-target speed interpolation factor which represents the value applicable to the limit.")

_ui.velocity_interp_offset_slider =  gui.Slider(_tab.movement, "velocity.interp.offset.slider", "Speed Interpolation Offset", 0, -100, 100)
_ui.velocity_interp_offset_slider:SetDescription("Set local & spec-target speed interpolation offset which represents the value that applicable to the limit.")

_ui.velocity_interp_start_color = gui.ColorPicker(_tab.movement, "velocity.interp.start.color", "Speed Interpolation Start Color", unpack(_default.interp_start_color))

_ui.velocity_interp_middle_color = gui.ColorPicker(_tab.movement, "velocity.interp.middle.color", "Speed Interpolation Middle Color", unpack(_default.interp_mid_color))

_ui.velocity_interp_end_color = gui.ColorPicker(_tab.movement, "velocity.interp.end.color", "Speed Interpolation End Color", unpack(_default.interp_end_color))

_ui.velocity_far_color = gui.ColorPicker(_tab.movement, "velocity.far.color", "Speed Far Color", unpack(_default.vel_far_color))

_ui.velocity_far_slider = gui.Slider(_tab.movement, "velocity.far.slider", "Speed Far Value", 340, 286, 480)
_ui.velocity_far_slider:SetDescription("Set local & spec-target speed limit for a far value.")

_ui.velocity_far_ladder_slider = gui.Slider(_tab.movement, "velocity.far.ladder.slider", "Speed Far Ladder Value", 310, 104, 312)
_ui.velocity_far_ladder_slider:SetDescription("Set local & spec-target speed limit for a far value while ladder moving.")

_ui.velocity_positive_color = gui.ColorPicker(_tab.movement, "velocity.positive.color", "Speed Positive Color", unpack(_default.vel_pos_color))

_ui.velocity_neutral_color = gui.ColorPicker(_tab.movement, "velocity.neutral.color", "Speed Neutral Color", unpack(_default.vel_neu_color))

_ui.velocity_negative_color = gui.ColorPicker(_tab.movement, "velocity.negative.color", "Speed Negative Color", unpack(_default.vel_neg_color))

_ui.velocity_neutral_color_disable_in_air_checkbox = gui.Checkbox(_tab.movement, "velocity.neutral.color.disable_in_air.checkbox", "Disable Speed Neutral Color In Air", true)
_ui.velocity_neutral_color_disable_in_air_checkbox:SetDescription("Disable render of neutral color while moving in the air.")

_ui.velocity_negative_color_disable_on_ground_checkbox = gui.Checkbox(_tab.movement, "velocity.negative.color.disable_on_ground.checkbox", "Disable Speed Negative Color On Ground", true)
_ui.velocity_negative_color_disable_on_ground_checkbox:SetDescription("Disable render of negative color while moving on the ground.")

_ui.velocity_neutral_color_ticks_slider = gui.Slider(_tab.movement, "velocity.neutral.color.ticks.slider", "Speed Neutral Color Ticks", 1, 0, 2)
_ui.velocity_neutral_color_ticks_slider:SetDescription("Set local & spec-target speed delay in ticks when changing color to neutral.")

_ui.velocity_negative_color_ticks_slider = gui.Slider(_tab.movement, "velocity.negative.color.ticks.slider", "Speed Negative Color Ticks", 1, 0, 2)
_ui.velocity_negative_color_ticks_slider:SetDescription("Set local & spec-target speed delay in ticks when changing color to negative.")

_ui.velocity_neutral_color_delta_error_slider = gui.Slider(_tab.movement, "velocity.neutral.color.delta_error.slider", "Speed Neutral Color Deleta Error", 0.5, 0, 1, 0.01)
_ui.velocity_neutral_color_delta_error_slider:SetDescription("Set local & spec-target speed delta error for neutral color.")

_ui.velocity_negative_color_delta_error_slider = gui.Slider(_tab.movement, "velocity.negative.color.delta_error.slider", "Speed Negative Color Delta Error", 0.5, 0, 1, 0.01)
_ui.velocity_negative_color_delta_error_slider:SetDescription("Set local & spec-target speed delta error for negative color.")

local velocity_latency_accumulator = 0

local local_player = nil
local local_flags = 0
local local_ground = 0
local local_prev_ground = 0
local local_duck = 0
local local_prev_duck = 0
local local_velocity = 0
local local_prev_velocity = 0
local local_take_velocity = nil
local local_prev_take_velocity = nil
local local_velocity_z = 0
local local_prev_velocity_z = 0
local local_delta_velocity = 0
local local_scope = false
local local_ladder = 0
local local_prev_ladder = 0
local local_ladder_glide = 0
local local_prev_ladder_glide = 0
local local_jump_type = _jt.none
local local_velocity_color = nil
local local_fake_velocity = 0
local local_fake_take_velocity = nil
local local_fake_velocity_color = nil

local local_fonts = {}

local local_fw_move = 0
local local_sw_move = 0

local local_pixel_surf = 0
local local_prev_pixel_surf = 0

local local_roof_trace = nil

local local_roof_distance = nil

local local_jb_button = 0

local function MovementUpdate(cmd)
    local origin = local_player:GetAbsOrigin()
    if (origin ~= nil) then
        local mins = local_player:GetMins()
        local maxs = local_player:GetMaxs()

        local source = Vector3(origin.x, origin.y, origin.z + maxs.z)
        local destination = Vector3(source.x, source.y, source.z + _default.tlen)

        maxs.z = 0

        local_roof_trace = engine.TraceHull(source, destination, mins, maxs)
        if (local_roof_trace.fraction ~= 1) then
            local_roof_distance = local_roof_trace.fraction * _default.tlen
        else
            local_roof_distance = nil
        end
    else
        local_roof_distance = nil
    end

    local_fw_move = cmd.forwardmove
    local_sw_move = cmd.sidemove

    local_flags = local_player:GetPropInt(_prop.flags)
    if (local_flags == nil) then
        local_flags = 0
    end

    local_prev_ground = local_ground
    if (bit.band(local_flags, _flag.on_ground) == _flag.on_ground) then
        if (local_ground < 0) then
            local_ground = 0
        end
        local_ground = local_ground + 1
    else
        if (local_ground > 0) then
            local_ground = 0
        end
        local_ground = local_ground - 1
    end

    local_prev_duck = local_duck
    if (bit.band(local_flags, _flag.ducking) == _flag.ducking) then
        if (local_duck < 0) then
            local_duck = 0
        end
        local_duck = local_duck + 1
    else
        if (local_duck > 0) then
            local_duck = 0
        end
        local_duck = local_duck - 1
    end

    local_prev_ladder = local_ladder
    if (local_player:GetPropInt(_prop.render) == _render.ladder) then
        if (local_ladder < 0) then
            local_ladder = 0
        end
        local_ladder = local_ladder + 1
    else
        if (local_ladder > 0) then
            local_ladder = 0
        end
        local_ladder = local_ladder - 1
    end

    local_prev_ladder_glide = local_ladder_glide
    if (local_ladder > 0 and bit.band(cmd.buttons, _button.in_jump) == _button.in_jump) then
        if (local_ladder_glide < 0) then
            local_ladder_glide = 0
        end
        local_ladder_glide = local_ladder_glide + 1
    else
        if (local_ladder_glide > 0) then
            local_ladder_glide = 0
        end
        local_ladder_glide = local_ladder_glide - 1
    end

    local velocity_x = local_player:GetPropFloat("localdata", _prop.vel_x)
    if (velocity_x == nil) then
        velocity_x = 0
    end
    local velocity_y = local_player:GetPropFloat("localdata", _prop.vel_y)
    if (velocity_y == nil) then
        velocity_y = 0
    end
    local velocity_z = local_player:GetPropFloat("localdata", _prop.vel_z)
    if (velocity_z == nil) then
        velocity_z = 0
    end

    local_prev_velocity_z = local_velocity_z
    local_velocity_z = velocity_z

    if (_ui.velocity_ladder_checkbox:GetValue() and local_ladder > 0 and local_ground < 0 and local_ladder_glide < 0) then
        local_prev_velocity = math.abs(local_prev_velocity_z)
        local_velocity = math.abs(local_velocity_z)
    else
        local_prev_velocity = local_velocity

        local velocity_accumulator = 0
        if (_ui.velocity_x_checkbox:GetValue()) then
            velocity_accumulator = velocity_accumulator + velocity_x^2
        end
        if (_ui.velocity_y_checkbox:GetValue()) then
            velocity_accumulator = velocity_accumulator + velocity_y^2
        end
        if (_ui.velocity_z_checkbox:GetValue()) then
            velocity_accumulator = velocity_accumulator + velocity_z^2
        end

        local_velocity = math.sqrt(velocity_accumulator)
    end

    local_delta_velocity = local_velocity - local_prev_velocity
    if (math.abs(local_delta_velocity) < 10^-3) then
        local_delta_velocity = 0
    end

    local is_ignored_flags = bit.band(local_flags, _flag.water_jump) == _flag.water_jump or bit.band(local_flags, _flag.swim) == _flag.swim or bit.band(local_flags, _flag.in_water) == _flag.in_water
    local is_ignored_movetype = local_ladder > 0 or is_ignored_flags

    local_prev_pixel_surf = local_pixel_surf
    if (local_ground < 0 and not is_ignored_movetype and local_velocity_z == -6.25) then
        if (local_pixel_surf < 0) then
            local_pixel_surf = 0
        end
        local_pixel_surf = local_pixel_surf + 1
    else
        if (local_pixel_surf > 0) then
            local_pixel_surf = 0
        end
        local_pixel_surf = local_pixel_surf - 1
    end

    local is_pixel_surfed = local_pixel_surf < 0 and local_prev_pixel_surf > 1
    local is_edge_bugged = local_pixel_surf < 0 and local_prev_pixel_surf == 1 and (local_ground == 1 and local_velocity_z == 0 or local_prev_ground < -1 and local_ground < -2) and (local_roof_distance == nil or local_roof_distance > 0.2)
    local is_head_hitted = local_pixel_surf < 0 and local_prev_pixel_surf == 1 and (local_ground == 1 and local_velocity_z == 0 or local_prev_ground < -1 and local_ground < -2) and (local_roof_distance ~= nil and local_roof_distance < 0.2)
    local is_jump_bugged = local_prev_duck > 0 and local_duck < 0 and not is_ignored_movetype and local_ground < 0 and local_prev_velocity_z < 0 and local_velocity_z > 0
    local is_ladder_jumped = local_ladder < 0 and local_prev_ladder > 0
    local is_ladder_glided = local_ladder_glide < 0 and local_prev_ladder_glide > 0
    local is_ladder_hopped = is_ladder_jumped and local_ground == -1 and local_prev_ground > 0

    local_prev_take_velocity = local_take_velocity
    if (local_ground > _ui.velocity_takeoff_time_slider:GetValue() * (1 / globals.TickInterval()) + 1 or is_ignored_flags or (not _ui.velocity_takeoff_ignore_ladder_checkbox:GetValue() and local_ladder > 0 and local_ladder_glide < 0) or (not _ui.velocity_takeoff_ignore_ladder_glide_checkbox:GetValue() and local_ladder_glide > 0)) then
            local_jump_type = _jt.none
            local_take_velocity = nil
    elseif (is_ladder_hopped) then
        if (_ui.velocity_takeoff_lah_checkbox:GetValue()) then
            local_jump_type = _jt.lah
            local_take_velocity = local_velocity
        end
        if (_ui.debug_checkbox:GetValue()) then
            print("Ladder Hop!")
        end
    elseif (is_ladder_glided) then
        if (_ui.velocity_takeoff_lag_checkbox:GetValue()) then
            local_jump_type = _jt.lag
            local_take_velocity = local_velocity
        end
        if (_ui.debug_checkbox:GetValue()) then
            print("Ladder Glide!")
        end
    elseif (is_ladder_jumped) then
        if (_ui.velocity_takeoff_laj_checkbox:GetValue()) then
            local_jump_type = _jt.laj
            local_take_velocity = local_velocity
        end
        if (_ui.debug_checkbox:GetValue()) then
            print("Ladder Jump!")
        end
    elseif (is_jump_bugged) then
        if (_ui.velocity_takeoff_jb_checkbox:GetValue()) then
            local_jump_type = _jt.jb
            local_take_velocity = math.min(286, math.max(0, local_velocity))
        end
        if (_ui.debug_checkbox:GetValue()) then
            print("Jump-Bug!")
        end
    elseif (is_pixel_surfed) then
        if (_ui.velocity_takeoff_ps_checkbox:GetValue()) then
            local_jump_type = _jt.ps
            local_take_velocity = local_velocity
        end
        if (_ui.debug_checkbox:GetValue()) then
            print("Pixel-Surf!")
        end
    elseif (is_edge_bugged) then
        if (_ui.velocity_takeoff_eb_checkbox:GetValue()) then
            local_jump_type = _jt.eb
            local_take_velocity = local_velocity
        end
        if (_ui.debug_checkbox:GetValue()) then
            print("Edge-Bug! " .. tostring(local_roof_distance))
        end
    elseif (is_head_hitted) then
        if (_ui.velocity_takeoff_hh_checkbox:GetValue()) then
            local_jump_type = _jt.hh
            local_take_velocity = local_velocity
        end
        if (_ui.debug_checkbox:GetValue()) then
            print("Head Hit! " .. tostring(local_roof_distance))
        end
    elseif (local_ground == -1 and local_ladder < 0) then
        if (local_prev_ground == 1 and local_velocity > 0) then
            if (_ui.velocity_takeoff_perfect_checkbox:GetValue()) then
                local_jump_type = _jt.perfect
                local_take_velocity = math.min(286, math.max(0, local_velocity))
            end
            if (_ui.debug_checkbox:GetValue()) then
                print("Perfect Jump!")
            end
        else
            if (_ui.velocity_takeoff_jump_checkbox:GetValue()) then
                local_jump_type = _jt.jump
                local_take_velocity = local_prev_ground == 1 and local_velocity or local_prev_velocity
            end
            if (_ui.debug_checkbox:GetValue()) then
                print("Normal Jump! " .. tostring(bit.band(cmd.buttons, _button.in_jump) == _button.in_jump))
            end
        end
    end

    local velocity_latency = _ui.velocity_latency_slider:GetValue()
    if (velocity_latency ~= 0) then
        velocity_latency_accumulator = velocity_latency_accumulator + globals.TickInterval()
        if (velocity_latency_accumulator >= velocity_latency) then
            velocity_latency_accumulator = math.fmod(velocity_latency_accumulator, velocity_latency)
            local_fake_velocity = local_velocity
            local_fake_take_velocity = local_take_velocity
            local_fake_velocity_color = local_velocity_color
        end
    else
        velocity_latency_accumulator = 0
        local_fake_velocity = local_velocity
        local_fake_take_velocity = local_take_velocity
        local_fake_velocity_color = local_velocity_color
    end

    if (_ui.jb_checkbox:GetValue()) then
        local jb_button = gui.GetValue(_var.jb)
        if (not _ref.menu:IsActive()) then
            if (entities.GetLocalPlayer():IsAlive()) then
                if (local_ground > (_ui.jb_auto_jump_checkbox:GetValue() and 1 or 0) or local_ladder > 0) then
                    if (jb_button ~= 0) then
                        local_jb_button = jb_button
                        gui.SetValue(_var.jb, 0)
                    end
                elseif (local_jb_button ~= 0) then
                    gui.SetValue(_var.jb, local_jb_button)
                end
                if (_ui.jb_lag_checkbox:GetValue() and local_ladder > 0 and local_jb_button ~= 0 and input.IsButtonDown(local_jb_button)) then
                    cmd.buttons = bit.bor(cmd.buttons, _button.in_jump)
                end
            elseif (jb_button == 0 and local_jb_button ~= 0) then
                gui.SetValue(_var.jb, local_jb_button)
            end
        elseif (jb_button == 0 and local_jb_button ~= 0) then
            gui.SetValue(_var.jb, local_jb_button)
        end
    end

    if (entities.GetLocalPlayer():IsAlive() and _ui.laj_checkbox:GetValue() and local_ladder < 0 and local_prev_ladder > 0 and (_ui.laj_ground_checkbox:GetValue() or local_ground < 0)) then
        if (local_fw_move > 0 and (local_sw_move < 0 or local_sw_move > 0)) then
            local fw_alias = _ui.laj_alias_fw_editbox:GetValue()
            if (fw_alias == nil or fw_alias == "") then
                fw_alias = _default.laj_fw_alias
            end
            client.Command(fw_alias, true)
        elseif (local_fw_move < 0 and (local_sw_move > 0 or local_sw_move < 0)) then
            local bw_alias = _ui.laj_alias_bw_editbox:GetValue()
            if (bw_alias == nil or bw_alias == "") then
                bw_alias = _default.laj_bw_alias
            end
            client.Command(bw_alias, true)
        end
    end

    if (entities.GetLocalPlayer():IsAlive() and _ui.ej_checkbox:GetValue() and input.IsButtonDown(gui.GetValue(_var.ej)) and local_prev_ground > 0 and local_ground == -1) then
        if (local_fw_move > 0) then
            local fw_alias = _ui.ej_alias_fw_editbox:GetValue()
            if (fw_alias == nil or fw_alias == "") then
                fw_alias = _default.ej_fw_alias
            end
            client.Command(fw_alias, true)
        elseif (local_fw_move < 0) then
            local bw_alias = _ui.ej_alias_bw_editbox:GetValue()
            if (bw_alias == nil or bw_alias == "") then
                bw_alias = _default.ej_bw_alias
            end
            client.Command(bw_alias, true)
        elseif (local_sw_move > 0) then
            local right_alias = _ui.ej_alias_rt_editbox:GetValue()
            if (right_alias == nil or right_alias == "") then
                right_alias = _default.ej_rt_alias
            end
            client.Command(right_alias, true)
        elseif (local_sw_move < 0) then
            local left_alias = _ui.ej_alias_lt_editbox:GetValue()
            if (left_alias == nil or left_alias == "") then
                left_alias = _default.ej_lt_alias
            end
            client.Command(left_alias, true)
        end
    end

    if (entities.GetLocalPlayer():IsAlive() and bit.band(cmd.buttons, _button.in_jump) == _button.in_jump and local_ground == -1 and (_ui.lj_checkbox:GetValue() and input.GetMouseWheelDelta() == 0 and local_prev_ground >= _ui.lj_ticks_slider:GetValue() or _ui.lj_scroll_checkbox:GetValue() and input.GetMouseWheelDelta() ~= 0 and local_prev_ground >= _ui.lj_scroll_ticks_slider:GetValue())) then
        if (local_fw_move > 0) then
            local fw_alias = _ui.lj_alias_fw_editbox:GetValue()
            if (fw_alias == nil or fw_alias == "") then
                fw_alias = _default.lj_fw_alias
            end
            client.Command(fw_alias, true)
        elseif (local_fw_move < 0) then
            local bw_alias = _ui.lj_alias_bw_editbox:GetValue()
            if (bw_alias == nil or bw_alias == "") then
                bw_alias = _default.lj_bw_alias
            end
            client.Command(bw_alias, true)
        elseif (local_sw_move > 0) then
            local right_alias = _ui.lj_alias_right_editbox:GetValue()
            if (right_alias == nil or right_alias == "") then
                right_alias = _default.lj_rt_alias
            end
            client.Command(right_alias, true)
        elseif (local_sw_move < 0) then
            local left_alias = _ui.lj_alias_left_editbox:GetValue()
            if (left_alias == nil or left_alias == "") then
                left_alias = _default.lj_lt_alias
            end
            client.Command(left_alias, true)
        end
    end

    local_scope = local_player:GetPropBool(_prop.scope)
    if (_ui.spread_checkbox:GetValue()) then
        if ((not _ui.spread_hide_checkbox:GetValue() or not local_scope) and (_util.in_range(tonumber(client.GetConVar(_con.crosshair_style)), 2, 3) and entities.GetLocalPlayer():IsAlive())) then
            local inaccuracy = local_player:GetWeaponInaccuracy()
            local is_enabled = (inaccuracy ~= nil and inaccuracy or 0) > _ui.spread_start_slider:GetValue()
            client.SetConVar(_con.debug_spread, is_enabled and 1 or _default.debug_spread, true)
        else
            client.SetConVar(_con.debug_spread, local_scope and _default.debug_spread or 2, true)
        end
    elseif (tonumber(client.GetConVar(_con.debug_spread)) ~= _default.debug_spread) then
        client.SetConVar(_con.debug_spread, _default.debug_spread, true)
    end

    if (_ui.weapon_sway_checkbox:GetValue()) then
        client.SetConVar(_con.wpn_sway, _ui.weapon_sway_scale_slider:GetValue(), true)
    elseif (tonumber(client.GetConVar(_con.wpn_sway)) ~= _default.wpn_sway) then
        client.SetConVar(_con.wpn_sway, _default.wpn_sway, true)
    end
end
local function ColorUpdate()
    if (_ui.velocity_rainbow_checkbox:GetValue()) then
        local cycle_time = _ui.velocity_rainbow_cycle_time_slider:GetValue()
        local hue_shift = _ui.velocity_rainbow_hue_shift_slider:GetValue()
        local hue_factor = cycle_time / globals.TickInterval()
        local hue_value = _ui.velocity_rainbow_rely_checkbox:GetValue() and local_velocity * (1 / globals.TickInterval()) / 64 or globals.TickCount()
        local hue = math.fmod(math.fmod(hue_value, hue_factor) / hue_factor + hue_shift, 1)
        local_velocity_color = {_util.hsb_to_rgb(hue, 1, 1, 1)}
    elseif (_ui.velocity_interp_checkbox:GetValue()) then
        local limit = nil
        if (local_ladder > 0 and local_ladder_glide < 0) then
            limit = _ui.velocity_interp_ladder_limit_slider:GetValue()
        elseif (_ui.velocity_interp_weapon_limit_checkbox:GetValue()) then
            limit = _default.weapon_speed[local_player:GetWeaponID()]
        end
        if (limit == nil) then
            limit = _ui.velocity_interp_limit_slider:GetValue()
        end

        local offset = _ui.velocity_interp_offset_slider:GetValue() / 100

        offset = limit * offset
        limit = limit + offset

        local ratio = local_velocity / limit
        ratio = ratio > 1 and 1 or ratio
        ratio = ratio - ratio * _ui.velocity_interp_factor_slider:GetValue() / 100

        local_velocity_color = {_util.interp_color3({_ui.velocity_interp_start_color:GetValue()}, {_ui.velocity_interp_middle_color:GetValue()}, {_ui.velocity_interp_end_color:GetValue()}, ratio)}
    elseif (local_delta_velocity >= 0) then
        if (local_velocity >= (local_ladder > 0 and _ui.velocity_far_ladder_slider:GetValue() or _ui.velocity_far_slider:GetValue())) then
            local_velocity_color = {_ui.velocity_far_color:GetValue()}
        elseif ((not _ui.velocity_neutral_color_disable_in_air_checkbox:GetValue() and local_ground < 0 or local_ground > _ui.velocity_neutral_color_ticks_slider:GetValue()) and math.abs(local_delta_velocity) <= _ui.velocity_neutral_color_delta_error_slider:GetValue()) then
            local_velocity_color = {_ui.velocity_neutral_color:GetValue()}
        elseif (local_delta_velocity > 0) then
            local_velocity_color = {_ui.velocity_positive_color:GetValue()}
        end
    elseif ((not _ui.velocity_negative_color_disable_on_ground_checkbox:GetValue() and local_ground > 0 or local_ground < 0) and not _util.in_range(math.abs(local_ground), 0, _ui.velocity_negative_color_ticks_slider:GetValue()) and local_delta_velocity < -_ui.velocity_negative_color_delta_error_slider:GetValue()) then
        local_velocity_color = {_ui.velocity_negative_color:GetValue()}
    end

    if (local_velocity_color ~= nil) then
        if (_ui.velocity_alpha_checkbox:GetValue()) then
            local limit = nil
            if (local_ladder > 0 and local_ladder_glide < 0) then
                limit = _ui.velocity_alpha_ladder_limit_slider:GetValue()
            elseif (_ui.velocity_alpha_weapon_checkbox:GetValue()) then
                limit = _default.weapon_speed[local_player:GetWeaponID()]
            end
            if (limit == nil) then
                limit = _ui.velocity_alpha_limit_slider:GetValue()
            end

            local offset = _ui.velocity_alpha_offset_slider:GetValue() / 100

            offset = limit * offset
            limit = limit + offset

            local ratio = local_velocity / limit
            ratio = ratio > 1 and 1 or ratio
            ratio = ratio - ratio * _ui.velocity_alpha_factor_slider:GetValue() / 100
            local_velocity_color[4] = ratio * 255
        end

        local saturation = _ui.velocity_color_saturation_slider:GetValue()
        local brightness = _ui.velocity_color_brightness_slider:GetValue()
        local h, s, b, a = _util.rgb_to_hsb(unpack(local_velocity_color))
        local_velocity_color = {_util.hsb_to_rgb(h, s * saturation, b * brightness, a)}
    end
end

local function MovementRender()
    if (screen_width == nil or screen_height == nil or local_fake_velocity_color == nil) then
        return
    end

    local font_name = _ui.font.keys[_ui.velocity_font_name_combobox:GetValue() + 1]
    local font_size = _ui.velocity_font_size_slider:GetValue()
    local font_weight = _ui.velocity_font_weight_slider:GetValue()
    if (local_fonts[font_name] == nil) then
        local_fonts[font_name] = {}
    end
    if (local_fonts[font_name][font_size] == nil) then
        local_fonts[font_name][font_size] = {}
    end
    if (local_fonts[font_name][font_size][font_weight] == nil) then
        local_fonts[font_name][font_size][font_weight] = draw.CreateFont(font_name, font_size, font_weight)
    end

    draw.SetFont(local_fonts[font_name][font_size][font_weight])

    local space_text_size = {draw.GetTextSize(" ")}
    local space_text_width = space_text_size[1]
    local space_text_height = space_text_size[2]

    if (not _ui.velocity_hide_checkbox:GetValue() or not local_scope) then
        local velocity_accuracy = _ui.velocity_accuracy_slider:GetValue()
        local velocity_text = string.format("%." .. tostring(velocity_accuracy) .. "f", local_fake_velocity)

        local velocity_text_brackets = _ui.bracket[_ui.bracket.keys[_ui.velocity_brackets_combobox:GetValue() + 1]]
        if (velocity_text_brackets == nil) then
            velocity_text_brackets = {"", ""}
        end
        velocity_text = velocity_text_brackets[1] .. velocity_text .. velocity_text_brackets[2]

        if (_ui.velocity_measurement_checkbox:GetValue()) then
            local velocity_measurement_text_separator = _ui.separator[_ui.separator.keys[_ui.velocity_measurement_separator_combobox:GetValue() + 1]]
            if (velocity_measurement_text_separator == nil) then
                velocity_measurement_text_separator = ""
            end

            local velocity_measurement_text_brackets = _ui.bracket[_ui.bracket.keys[_ui.velcoity_measurement_brackets_combobox:GetValue() + 1]]
            if (velocity_measurement_text_brackets == nil) then
                velocity_measurement_text_brackets = {"", ""}
            end

            local velocity_measurement_text = _ui.format[_ui.format.keys[_ui.velocity_measurement_format_combobox:GetValue() + 1]]
            if (velocity_measurement_text == nil) then
                velocity_measurement_text = ""
            end

            local velocity_measurement_text_fn = _ui.case[_ui.case.keys[_ui.velocity_measurement_case_combobox:GetValue() + 1]]
            if (velocity_measurement_text_fn ~= nil) then
                velocity_text = velocity_text .. velocity_measurement_text_separator .. velocity_measurement_text_brackets[1] .. velocity_measurement_text_fn(velocity_measurement_text) .. velocity_measurement_text_brackets[2]
            end
        end

        local velocity_text_size = {draw.GetTextSize(velocity_text)}
        local velocity_text_width = velocity_text_size[1]
        local velocity_text_height = velocity_text_size[2]

        local velocity_text_position_x = screen_width * _ui.velocity_position_x_slider:GetValue() / 100
        local velocity_text_position_y = screen_height * (100 - _ui.velocity_position_y_slider:GetValue()) / 100

        velocity_text_position_x = velocity_text_position_x - velocity_text_width / 2
        velocity_text_position_y = velocity_text_position_y - velocity_text_height / 2

        local shadow_offset_x = _ui.velocity_shadow_offset_x_slider:GetValue()
        local shadow_offset_y = _ui.velocity_shadow_offset_y_slider:GetValue()
        local shadow_color = {_ui.velocity_shadow_color:GetValue()}
        shadow_color[4] = (shadow_color[4] * local_fake_velocity_color[4]) / 255

        if (_ui.velocity_shadow_checkbox:GetValue()) then
            draw.Color(unpack(shadow_color))
            draw.Text(velocity_text_position_x + shadow_offset_x, velocity_text_position_y + shadow_offset_y, velocity_text)
        end

        draw.Color(unpack(local_fake_velocity_color))
        draw.Text(velocity_text_position_x, velocity_text_position_y, velocity_text)

        if (_ui.velocity_takeoff_checkbox:GetValue() and local_fake_take_velocity ~= nil) then
            local take_velocity_text = string.format("%." .. tostring(velocity_accuracy) ..  "f", local_fake_take_velocity)

            local take_velocity_text_brackets = _ui.bracket[_ui.bracket.keys[_ui.velocity_takeoff_brackets_combobox:GetValue() + 1]]
            if (take_velocity_text_brackets == nil) then
                take_velocity_text_brackets = {"", ""}
            end
            take_velocity_text = take_velocity_text_brackets[1] .. take_velocity_text .. take_velocity_text_brackets[2]

            local take_velocity_text_size = {draw.GetTextSize(take_velocity_text)}
            local take_velocity_text_width = take_velocity_text_size[1]
            local take_velocity_text_height = take_velocity_text_size[2]

            local take_velocity_text_position_x = velocity_text_position_x + (velocity_text_width - take_velocity_text_width) / 2
            local take_velocity_text_position_y = velocity_text_position_y + velocity_text_height + space_text_height

            if (_ui.velocity_shadow_checkbox:GetValue()) then
                draw.Color(unpack(shadow_color))
                draw.Text(take_velocity_text_position_x + shadow_offset_x, take_velocity_text_position_y + shadow_offset_y, take_velocity_text)
            end

            draw.Color(unpack(local_fake_velocity_color))
            draw.Text(take_velocity_text_position_x, take_velocity_text_position_y, take_velocity_text)
        end
    end

    if (_ui.debug_checkbox:GetValue()) then
        draw.Color(unpack(_default.vel_pos_color))
        draw.Text(42, 42, tostring(local_pixel_surf) .. " <-> " .. string.format("%.2f", local_velocity_z) .. " | " .. string.format("%.3f", local_roof_trace ~= nil and local_roof_trace.fraction or 1) .. "; " .. (local_roof_distance ~= nil and string.format("%.3f", local_roof_distance) or tostring(local_roof_distance)))
    end
end
