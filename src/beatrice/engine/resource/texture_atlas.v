module resource

import stbi
import thirdparty.sokol.gfx

pub struct AtlasEntry {
	ImageResource
pub mut:
	width  int
	height int

	x_offset int
	y_offset int

	atlas &TextureAtlas
}

pub struct TextureAtlas {
	Resource
mut:
	last_x_offset   int
	last_y_offset   int
	last_row_height int
pub mut:
	name  string
	atlas gfx.Image

	width  int
	height int

	textures []&AtlasEntry
	data     []u8

	changed bool
}

pub fn (atlas &TextureAtlas) get_uv_coords(texture &AtlasEntry) (f32, f32, f32, f32) {
	u0 := f32(texture.x_offset) / f32(atlas.width)
	v0 := f32(texture.y_offset) / f32(atlas.height)

	u1 := f32(texture.x_offset + texture.width) / f32(atlas.width)
	v1 := f32(texture.y_offset + texture.height) / f32(atlas.height)

	return u0, v0, u1, v1
}

@[direct_array_access]
pub fn (mut atlas TextureAtlas) update() {
	if atlas.changed {
		mut data := gfx.ImageData{}
		data.subimage[0][0] = gfx.Range{
			ptr:  atlas.data.data
			size: usize(atlas.width * atlas.height * 4)
		}

		gfx.update_image(atlas.atlas, &data)

		atlas.changed = false
	}
}

@[direct_array_access]
pub fn (mut atlas TextureAtlas) add_texture_from_file(path string) &AtlasEntry {
	stb_img := stbi.load(path) or { panic(err) }

	mut x_offset := atlas.last_x_offset
	mut y_offset := atlas.last_y_offset

	if x_offset + stb_img.width > atlas.width {
		x_offset = 0
		y_offset += atlas.last_row_height
		atlas.last_row_height = 0
	}

	if stb_img.height > atlas.last_row_height {
		atlas.last_row_height = stb_img.height
	}

	mut atlas_entry := &AtlasEntry{
		width:    stb_img.width
		height:   stb_img.height
		x_offset: x_offset
		y_offset: y_offset
		atlas:    unsafe { &atlas }
	}

	atlas.textures << unsafe { atlas_entry }

	for y := 0; y < stb_img.height; y++ {
		atlas_row_offset := (y + y_offset) * atlas.width * 4 + x_offset * 4 // Use x_offset to shift horizontally
		stb_row_offset := y * stb_img.width * 4

		unsafe {
			C.memcpy(&u8(atlas.data.data) + atlas_row_offset, stb_img.data + stb_row_offset,
				stb_img.width * 4)
		}
	}

	atlas.last_x_offset = x_offset + stb_img.width
	atlas.last_y_offset = y_offset

	atlas.changed = true
	stb_img.free()

	return atlas_entry
}

pub fn (mut atlas TextureAtlas) add_texture_from_stbi(stb_img &stbi.Image) &AtlasEntry {
	mut x_offset := atlas.last_x_offset
	mut y_offset := atlas.last_y_offset

	if x_offset + stb_img.width > atlas.width {
		x_offset = 0
		y_offset += atlas.last_row_height
		atlas.last_row_height = 0
	}

	if stb_img.height > atlas.last_row_height {
		atlas.last_row_height = stb_img.height
	}

	mut atlas_entry := &AtlasEntry{
		width:    stb_img.width
		height:   stb_img.height
		x_offset: x_offset
		y_offset: y_offset
		atlas:    unsafe { &atlas }
	}

	atlas.textures << unsafe { atlas_entry }

	for y := 0; y < stb_img.height; y++ {
		atlas_row_offset := (y + y_offset) * atlas.width * 4 + x_offset * 4 // Use x_offset to shift horizontally
		stb_row_offset := y * stb_img.width * 4

		unsafe {
			C.memcpy(&u8(atlas.data.data) + atlas_row_offset, stb_img.data + stb_row_offset,
				stb_img.width * 4)
		}
	}

	atlas.last_x_offset = x_offset + stb_img.width
	atlas.last_y_offset = y_offset

	atlas.changed = true
	stb_img.free()

	return atlas_entry
}

pub fn TextureAtlas.create(width int, height int) &TextureAtlas {
	mut texture_atlas := &TextureAtlas{
		data: []u8{len: width * height * 4}
	}

	unsafe { C.memset(texture_atlas.data.data, 0, width * height * 4 * int(sizeof(u8))) }

	texture_atlas.width = width
	texture_atlas.height = height

	mut img_desc := gfx.ImageDesc{
		width:        width
		height:       height
		pixel_format: .rgba8
		usage:        .stream
	}
	img_desc.data.subimage[0][0] = gfx.Range{
		ptr:  0
		size: usize(0)
	}

	texture_atlas.atlas = gfx.make_image(&img_desc)
	texture_atlas.changed = true

	return texture_atlas
}
