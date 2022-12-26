module backend

import gg
import gx
import src.beatrice.component.object
import src.beatrice.graphic.texture

pub const (
	i_am_being_used = 420
)

[heap]
pub struct GGBackend {
	BaseBackend
mut:
	typ   BackendType = .gg
	cache map[string]gg.Image
pub mut:
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
	mut texture := unsafe { &config.texture }

	if mut texture is gg.Image {
		gg_backend.ctx.draw_image_with_config(gg.DrawImageConfig{
			img: texture
			img_id: texture.id
			img_rect: gg.Rect{
				x: f32(config.position.x)
				y: f32(config.position.y)
				width: f32(config.size.x)
				height: f32(config.size.y)
			}
			color: gx.Color{u8(config.color.r), u8(config.color.g), u8(config.color.b), u8(config.color.a)}
			effect: gg.ImageEffect(config.effects)
		})
	}
}

// Init TODO
pub fn init() {
	println('[BACKEND] TODO')
}
