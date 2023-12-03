local Helper = require "keyboard_generator_helper"
helper = Helper:new{}

------------------------
--- OVERALL SETTINGS ---
-----------------------------------------------------------------------------------
precision = 1e-1
-- number of octaves to generate
helper:set_n_octaves(ui_numberBox("Number of octaves", helper.n_octaves))
-- space between moving keys
helper:set_key_gap(ui_scalarBox("Key gap", helper.key_gap, precision))

---------------------------------------
--- Make one octave of natural keys ---
-----------------------------------------------------------------------------------
ui_bool("Naturals settings", true)

-- number of extra natural keys to generate (with no cutouts for sharps)
helper:set_n_extra_naturals(ui_radio("Extra naturals?", {{0, "No"}, {1, "Yes"}}))
if helper.n_extra_naturals > 0 then
    helper:set_n_extara_naturals(ui_number("Number of extra naturals", helper.n_extra_naturals, 1, 5))
end

helper:set_naturals_width(ui_scalarBox("Naturals width", helper.naturals_width, precision))
helper:set_naturals_length(ui_scalarBox("Naturals length", helper.naturals_length, precision))
-- thickness of the flat top surface of the key
helper:set_top_thickness(ui_scalarBox("Top surface thickness", helper.top_thickness, precision))
-- select bottom section type
helper:set_recess_depth(ui_scalarBox("Recess depth", 1, precision))
helper:set_bottom_thickness(ui_scalarBox("Bottom thickness", helper.bottom_thickness, precision))
helper:update_bottom_section(ui_radio("Bottom section type", {{1, "Angled"}, {0, "Square"}}))
if helper.bottom_type == 1 then
    helper:set_bottom_angle(ui_scalarBox("Bottom angle", helper.angle, precision))
end

-------------------------------------
--- Make one octave of sharp keys ---
-----------------------------------------------------------------------------------
ui_bool("Sharps settings", true)

helper:set_sharps_width(ui_scalarBox("Sharps width", helper.sharps_width, precision))
helper:set_sharps_length(ui_scalarBox("Sharps length", helper.sharps_length, precision))
helper:set_sharps_height(ui_scalarBox("Sharps height", helper.sharps_height, precision))

-- C#-D# spacing
helper:set_cd_spacing(ui_scalarBox("C#-D# spacing", helper.cd_spacing, precision))
helper:set_fga_spacing(ui_scalarBox("F#-G#-A# spacing", helper.fga_spacing, precision))

-----------------
--- Emit keys ---
-----------------------------------------------------------------------------------
helper:emit_keys()
