------------------------
--- OVERALL SETTINGS ---
-----------------------------------------------------------------------------------
-- default values taken from reference materials
n_octaves_default = 1
n_extra_naturals_default = 1
key_gap_default = 0.5
-- ui selections for the overall settings
n_octaves = ui_scalarBox("Number of octaves", n_octaves_default, 1e-2)
key_gap = ui_scalarBox("Key gap", key_gap_default, 1e-2)

extra_keys = ui_radio("Extra keys", {{0, "No"}, {1, "Yes"}})
if extra_keys == 1 then
    n_extra_naturals = ui_scalarBox("Number of extra naturals", n_extra_naturals_default, 1e-2)
end

-------------------------
--- Make natural keys ---
-----------------------------------------------------------------------------------
naturals_width_default = 22.15
naturals_length_default = 126.27
-- thickness of the flat top surface of the key
top_thickness_default = 2.2

naturals_width = ui_scalarBox("Naturals width", naturals_width_default, 1e-2)
naturals_length = ui_scalarBox("Naturals length", naturals_length_default, 1e-2)
top_thickness = ui_scalarBox("Top surface thickness", top_thickness_default, 1e-2)

top_surface = cube(naturals_width, naturals_length, top_thickness)

-- bottom section 
bottom_type_list = {{1, "Angled"}, {0, "Square"}}
bottom_type = ui_radio("Bottom section type", bottom_type_list)

if bottom_type == 0 then
    bottom_thickness = ui_scalarBox("Bottom surface thickness", top_thickness * 5, 1e-2)
    recess_depth = ui_scalarBox("Recess depth", 1, 1e-2)

    bottom_section = translate(0, recess_depth / 2, -bottom_thickness) *
                         cube(naturals_width, naturals_length - recess_depth, bottom_thickness)
else
    bottom_thickness = ui_scalarBox("Bottom surface thickness", top_thickness * 5, 1e-2)
    recess_depth = ui_scalarBox("Recess depth", 1, 1e-2)

    bottom_section = translate(0, recess_depth / 2, -bottom_thickness) *
                         cube(naturals_width, naturals_length - recess_depth, bottom_thickness)

    angle = ui_scalarBox("Angle", 30, 1e-2)
    height = bottom_thickness
    depth = height * tan(angle)

    triangle = {v(0, 0, 0), v(0, depth, 0), v(0, 0, height)}
    cutout = linear_extrude(X * naturals_width, triangle)
    cutout = translate(-naturals_width / 2, -naturals_length / 2 + recess_depth, -bottom_thickness) * cutout

    bottom_section = difference(bottom_section, cutout)
end

-- generate the keys
natural_key = union(top_surface, bottom_section)

natural_translation = v(naturals_width + key_gap, 0, 0)
for i = 0, 6 * n_octaves do
    emit(translate(natural_translation * i) * natural_key)
end
