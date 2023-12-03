local NAME = "keyboard_generator_helper"

local Helper = {
    precision = 1e-2,
    n_octaves = 1,
    n_extra_naturals = 0,
    key_gap = 1.27,

    -- naturals
    n_naturals = 7,

    naturals_width = 22.15,
    naturals_length = 126.27,
    top_thickness = 2.2,
    top_surface = cube(0),

    bottom_type = 1,
    bottom_thickness = 2.2 * 5,
    recess_depth = 1,
    bottom_section = cube(0),
    angle = 30,

    natural_translation = v(0, 0, 0),
    natural_key = cube(0),
    natural_keys = {},

    -- sharps
    sharps_width = 11,
    sharps_length = 80,
    sharps_height = 10.5,

    sharp_translation = v(0, 0, 0),
    sharp_key = cube(0),
    sharp_keys = {},
    sharp_key_gap = cube(0),
    sharp_key_gaps = {},
    cd_spacing = 0,
    fga_spacing = 0
}

function Helper:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    -- self:update_natural_keys()
    self:update_sharp_keys()
    return o
end

function Helper:set_n_octaves(value)
    self.n_octaves = value
    return self.n_octaves
end

---[[ Natural keys stuff
function Helper:set_n_extra_naturals(value)
    self.n_extra_naturals = value
    return self.n_extra_naturals
end

function Helper:set_key_gap(value)
    self.key_gap = value
    return self.key_gap
end

function Helper:update_n_naturals()
    self.n_naturals = 6 * self.n_octaves + self.n_extra_naturals
    return self.n_naturals
end

function Helper:set_naturals_width(value)
    self.naturals_width = value
    self:update_natural_keys()
    return self.naturals_width
end

function Helper:set_naturals_length(value)
    self.naturals_length = value
    self:update_natural_keys()
    return self.naturals_length
end

function Helper:set_top_thickness(value)
    self.top_thickness = value
    self:update_top_surface()
    return self.top_thickness
end

function Helper:update_top_surface()
    self.top_surface = cube(self.naturals_width, self.naturals_length, self.top_thickness)
    self:update_natural_keys()
    return self.top_surface
end

function Helper:set_bottom_angle(value)
    self.angle = value
    self:update_bottom_section(1)
    return self.angle
end

function Helper:update_bottom_section(value)
    self.bottom_type = value
    if self.bottom_type == 0 then
        self.bottom_section = translate(0, self.recess_depth / 2, -self.bottom_thickness) *
                                  cube(self.naturals_width, self.naturals_length - self.recess_depth,
                self.bottom_thickness)
    else
        bottom_section = translate(0, self.recess_depth / 2, -self.bottom_thickness) *
                             cube(self.naturals_width, self.naturals_length - self.recess_depth, self.bottom_thickness)
        -- angle = ui_scalarBox("Angle", self.angle, self.precision)
        angle = self.angle
        height = self.bottom_thickness
        depth = height * tan(angle)
        triangle = {v(0, 0, 0), v(0, depth, 0), v(0, 0, height)}

        cutout = linear_extrude(X * self.naturals_width, triangle)
        cutout = translate(-self.naturals_width / 2, -self.naturals_length / 2 + self.recess_depth,
            -self.bottom_thickness) * cutout

        self.bottom_section = difference(bottom_section, cutout)
    end
    self:update_natural_keys()
    return self.bottom_type
end

function Helper:set_bottom_thickness(value)
    self.bottom_thickness = value
    return self.bottom_thickness
end

function Helper:set_recess_depth(value)
    self.recess_depth = value
    self:update_natural_keys()
    return self.recess_depth
end

function Helper:update_natural_keys()
    -- self:update_top_surface()
    -- self:update_bottom_section()

    self.natural_key = union(self.top_surface, self.bottom_section)
    self.natural_translation = v(self.naturals_width + self.key_gap, 0, 0)
    self.natural_keys = {}
    for i = 1, self.n_naturals do
        self.natural_keys[i] = translate(self.natural_translation * (i - 1)) * self.natural_key
        -- self.natural_keys[i] = self.natural_key
    end
    self:update_sharp_keys()
    return self.natural_keys
end
-- ]]

---[[ Sharp keys stuff
function Helper:set_sharps_width(value)
    self.sharps_width = value
    self:update_sharp_keys()
    return self.sharps_width
end

function Helper:set_sharps_length(value)
    self.sharps_length = value
    self:update_sharp_keys()
    return self.sharps_length
end

function Helper:set_sharps_height(value)
    self.sharps_height = value + self.bottom_thickness + self.top_thickness
    self:update_sharp_keys()
    return self.sharps_height
end

function Helper:set_cd_spacing(value)
    self.cd_spacing = value
    -- print(tostring(self.cd_spacing))
    self:update_sharp_keys()
    return self.cd_spacing
end

function Helper:set_fga_spacing(value)
    self.fga_spacing = value
    self:update_sharp_keys()
    return self.fga_spacing
end

function Helper:update_sharp_keys()
    sharp_translation = v(-self.naturals_width / 2, (self.naturals_length - self.sharps_length) / 2,
        -self.bottom_thickness)
    -- C#-D# spacing
    cde_width = self.naturals_width * 3 + self.key_gap * 2

    if self.cd_spacing == 0 then
        self.cd_spacing = (cde_width - (self.sharps_width * 2 + self.key_gap * 4)) / 3
    end

    -- C#
    cd_translation = sharp_translation +
                         v(cde_width / 2 - self.cd_spacing / 2 - self.sharps_width / 2 - self.key_gap, 0, 0)
    self.sharp_key = cube(self.sharps_width, self.sharps_length, self.sharps_height)
    self.sharp_key = translate(cd_translation) * self.sharp_key
    self.sharp_key_gap = cube(self.sharps_width + 2 * self.key_gap, self.sharps_length + 2 * self.key_gap,
        self.sharps_height)
    self.sharp_key_gap = translate(cd_translation) * self.sharp_key_gap

    self.sharp_keys = {}
    for i = 1, 5 do
        -- this is just filler
        self.sharp_keys[i] = translate(sharp_translation * (i - 1)) * self.sharp_key
    end
    self.sharp_keys[1] = self.sharp_key

    self.sharp_key_gaps = {}
    for i = 1, 5 do
        -- this is just filler
        self.sharp_key_gaps[i] = translate(sharp_translation * (i - 1)) * self.sharp_key_gap
    end
    self.sharp_key_gaps[1] = self.sharp_key_gap

    -- D#
    de_translation = sharp_translation +
                         v(cde_width / 2 + self.cd_spacing / 2 + self.sharps_width / 2 + self.key_gap, 0, 0)

    self.sharp_key = cube(self.sharps_width, self.sharps_length, self.sharps_height)
    self.sharp_key = translate(de_translation) * self.sharp_key
    self.sharp_keys[2] = self.sharp_key

    self.sharp_key_gap = cube(self.sharps_width + 2 * self.key_gap, self.sharps_length + 2 * self.key_gap,
        self.sharps_height)
    self.sharp_key_gap = translate(de_translation) * self.sharp_key_gap
    self.sharp_key_gaps[2] = self.sharp_key_gap

    -- F#
    fgab_width = self.naturals_width * 4 + self.key_gap * 3

    if self.fga_spacing == 0 then
        self.fga_spacing = (fgab_width - (self.sharps_width * 3 + self.key_gap * 6)) / 4
    end

    fg_translation = sharp_translation +
                         v(
            self.naturals_width * 3 + self.key_gap * 3 + fgab_width / 2 - self.sharps_width - self.fga_spacing -
                self.key_gap * 2, 0, 0)

    self.sharp_key = cube(self.sharps_width, self.sharps_length, self.sharps_height)
    self.sharp_key = translate(fg_translation) * self.sharp_key
    self.sharp_keys[3] = self.sharp_key

    self.sharp_key_gap = cube(self.sharps_width + 2 * self.key_gap, self.sharps_length + 2 * self.key_gap,
        self.sharps_height)
    self.sharp_key_gap = translate(fg_translation) * self.sharp_key_gap
    self.sharp_key_gaps[3] = self.sharp_key_gap

    -- G#
    ga_translation = sharp_translation + v(self.naturals_width * 3 + self.key_gap * 3 + fgab_width / 2, 0, 0)

    self.sharp_key = cube(self.sharps_width, self.sharps_length, self.sharps_height)
    self.sharp_key = translate(ga_translation) * self.sharp_key
    self.sharp_keys[4] = self.sharp_key

    self.sharp_key_gap = cube(self.sharps_width + 2 * self.key_gap, self.sharps_length + 2 * self.key_gap,
        self.sharps_height)
    self.sharp_key_gap = translate(ga_translation) * self.sharp_key_gap
    self.sharp_key_gaps[4] = self.sharp_key_gap

    -- A#
    ab_translation = sharp_translation +
                         v(
            self.naturals_width * 3 + self.key_gap * 3 + fgab_width / 2 + self.sharps_width + self.fga_spacing +
                self.key_gap * 2, 0, 0)

    self.sharp_key = cube(self.sharps_width, self.sharps_length, self.sharps_height)
    self.sharp_key = translate(ab_translation) * self.sharp_key
    self.sharp_keys[5] = self.sharp_key

    self.sharp_key_gap = cube(self.sharps_width + 2 * self.key_gap, self.sharps_length + 2 * self.key_gap,
        self.sharps_height)
    self.sharp_key_gap = translate(ab_translation) * self.sharp_key_gap
    self.sharp_key_gaps[5] = self.sharp_key_gap
end
-- ]]

function Helper:emit_keys()
    -- cut the sharp key gaps out of the natural keys
    for i in ipairs(self.natural_keys) do
        for ii in ipairs(self.sharp_key_gaps) do
            self.natural_keys[i] = difference(self.natural_keys[i], self.sharp_key_gaps[ii])
        end
    end

    for i in ipairs(self.natural_keys) do
        emit(self.natural_keys[i], 1)
    end

    for i in ipairs(self.sharp_keys) do
        emit(self.sharp_keys[i], 2)
    end
end

return Helper
