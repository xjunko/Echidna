module backend

import gg
import gx
import sokol.sgl
import beatrice.component.object
import beatrice.graphic.texture
import beatrice.math.vector

pub const (
	i_am_being_used = 420
)

[heap]
pub struct GGBackend {
	BaseBackend
mut:
	cache map[string]gg.Image
pub mut:
	typ BackendType = .gg
	ctx &gg.Context = unsafe { nil }
}

// OPs
pub fn (mut gg_backend GGBackend) begin() {
	gg_backend.ctx.begin()
}

pub fn (mut gg_backend GGBackend) end() {
	gg_backend.ctx.end()
}

// Utils
pub fn (gg_backend &GGBackend) text_width(text string) int {
	return gg_backend.ctx.text_width(text)
}

pub fn (gg_backend &GGBackend) text_height(text string) int {
	return gg_backend.ctx.text_height(text)
}

// Draw
pub fn (gg_backend &GGBackend) draw_rect_filled(x f64, y f64, width f64, height f64, color object.GameObjectColor[f64]) {
	gg_backend.ctx.draw_rect_filled(f32(x), f32(y), f32(width), f32(height), gx.Color{u8(color.r), u8(color.g), u8(color.b), u8(color.a)})
}

pub fn (gg_backend &GGBackend) draw_rect_empty(x f64, y f64, width f64, height f64, color object.GameObjectColor[f64]) {
	gg_backend.ctx.draw_rect_empty(f32(x), f32(y), f32(width), f32(height), gx.Color{u8(color.r), u8(color.g), u8(color.b), u8(color.a)})
}

pub fn (gg_backend &GGBackend) draw_text(x f64, y f64, text string, config gx.TextCfg) {
	gg_backend.ctx.draw_text(int(x), int(y), text, config)
}

// Image
pub fn (mut gg_backend GGBackend) create_image(path string) texture.ITexture {
	if path.to_lower() !in gg_backend.cache {
		gg_backend.cache[path.to_lower()] = gg_backend.ctx.create_image(path)
	}

	return unsafe { gg_backend.cache[path.to_lower()] }
}

pub fn (gg_backend &GGBackend) draw_image_with_config(config ImageDrawConfig) {
	gg_backend.draw_image_with_config_ex(config)
}

pub fn (gg_backend &GGBackend) draw_image_with_config_ex(config ImageDrawConfig) {
	// It's like gg's draw_image_with_config but with alignment support.
	// and without the checks.
	// NOTE: This is a hack.

	mut texture := unsafe { &config.texture }

	mut img := &gg.Image{}

	if mut texture is gg.Image {
		img = texture
	}

	if !img.simg_ok {
		panic('Image is not valid, this should never happen.')
	}

	mut image_pos := unsafe { &config.position }
	mut image_size := unsafe { &config.size }

	if image_size.x == 0 && image_size.y == 0 {
		image_size = &vector.Vector2[f64]{
			x: f64(img.width)
			y: f64(img.height)
		}
	}

	u0 := f32(0.0) // f32(image_pos.x) / f32(img.width)
	v0 := f32(0.0) // f32(image_pos.y) / f32(img.height)

	u1 := f32(1.0) // f32(img.width) / f32(img.width)
	v1 := f32(1.0) // f32(img.height) / f32(img.height)

	x0 := f32(image_pos.x * gg_backend.ctx.scale)
	y0 := f32(image_pos.y * gg_backend.ctx.scale)

	x1 := f32((image_pos.x + image_size.x) * gg_backend.ctx.scale)
	mut y1 := f32((image_pos.y + image_size.y) * gg_backend.ctx.scale)

	if image_size.y == 0.0 {
		scale := f32(img.width) / f32(image_size.x)
		y1 = f32(image_pos.y + int(f32(img.height) / scale)) * gg_backend.ctx.scale
	}

	// TODO: unused, but might in the future
	flip_x := false
	flip_y := false

	mut u0f := if !flip_x { u0 } else { u1 }
	mut u1f := if !flip_x { u1 } else { u0 }
	mut v0f := if !flip_y { v0 } else { v1 }
	mut v1f := if !flip_y { v1 } else { v0 }

	sgl.load_pipeline(gg_backend.ctx.pipeline.alpha)
	sgl.enable_texture()
	sgl.texture(img.simg)

	// Here comes the fun part
	if config.angle != 0.0 {
		width := f32(image_size.x * gg_backend.ctx.scale)
		height := f32((if image_size.y > 0 { image_size.y } else { img.height }) * gg_backend.ctx.scale)

		sgl.push_matrix()

		// kill me
		match config.origin.typ {
			// TOP
			.top_left {
				sgl.translate(x0, y0, 0)
				sgl.rotate(sgl.rad(-f32(config.angle)), 0, 0, 1)
				sgl.translate(-x0, -y0, 0)
			}
			.top_centre {
				sgl.translate(x0 + (width / 2), y0 - height, 0)
				sgl.rotate(sgl.rad(-f32(config.angle)), 0, 0, 1)
				sgl.translate(-x0 - (width / 2), -y0, 0)
			}
			.top_right {
				sgl.translate(x0 + width, y0 - height, 0)
				sgl.rotate(sgl.rad(-f32(config.angle)), 0, 0, 1)
				sgl.translate(-x0 - width, -y0, 0)
			}
			// CENTRE
			.centre_left {
				sgl.translate(x0, y0 + (height / 2), 0)
				sgl.rotate(sgl.rad(-f32(config.angle)), 0, 0, 1)
				sgl.translate(-x0, -y0 - (height / 2), 0)
			}
			.centre {
				sgl.translate(x0 + (width / 2), y0 + (height / 2), 0)
				sgl.rotate(sgl.rad(-f32(config.angle)), 0, 0, 1)
				sgl.translate(-x0 - (width / 2), -y0 - (height / 2), 0)
			}
			.centre_right {
				sgl.translate(x0 + width, y0 + (height / 2), 0)
				sgl.rotate(sgl.rad(-f32(config.angle)), 0, 0, 1)
				sgl.translate(-x0 - width, -y0 - (height / 2), 0)
			}
			// BOTTOM
			.bottom_left {
				sgl.translate(x0, y0 + height, 0)
				sgl.rotate(sgl.rad(-f32(config.angle)), 0, 0, 1)
				sgl.translate(-x0, -y0 - height, 0)
			}
			.bottom_centre {
				sgl.translate(x0 + (width / 2), y0 + height, 0)
				sgl.rotate(sgl.rad(-f32(config.angle)), 0, 0, 1)
				sgl.translate(-x0 - (width / 2), -y0 - height, 0)
			}
			.bottom_right {
				sgl.translate(x0 + width, y0 + height, 0)
				sgl.rotate(sgl.rad(-f32(config.angle)), 0, 0, 1)
				sgl.translate(-x0 - width, -y0 - height, 0)
			}
		}
	}

	sgl.begin_quads()
	sgl.c4b(u8(config.color.r), u8(config.color.g), u8(config.color.b), u8(config.color.a))
	sgl.v3f_t2f(x0, y0, config.z_index, u0f, v0f)
	sgl.v3f_t2f(x1, y0, config.z_index, u1f, v0f)
	sgl.v3f_t2f(x1, y1, config.z_index, u1f, v1f)
	sgl.v3f_t2f(x0, y1, config.z_index, u0f, v1f)
	sgl.end()

	if f32(config.angle) != 0 {
		sgl.pop_matrix()
	}

	sgl.disable_texture()

	// println('========')
	// println('${image_size.x} ${image_size.y} | ${image_pos.x} ${image_pos.y}')
	// println('${x0} ${y0} ${u0f} ${v0f}')
	// println('${x1} ${y0} ${u1f} ${v0f}')
	// println('${x1} ${y1} ${u1f} ${v1f}')
	// println('${x0} ${y1} ${u0f} ${v1f}')
	// println('========')
}
