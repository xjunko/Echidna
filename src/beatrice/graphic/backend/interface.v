module backend

import gx
import src.beatrice.component.object
import src.beatrice.graphic.texture
import src.beatrice.math.vector

// Types
pub enum BackendType {
	@none
	gg
	sdl
}

// Interface
pub interface IBackend {
	// FNs that doesnt need to be mutable
	draw_rect_filled(f64, f64, f64, f64, object.GameObjectColor[f64])
	draw_rect_empty(f64, f64, f64, f64, object.GameObjectColor[f64])
	draw_text(f64, f64, string, gx.TextCfg)
	draw_image_with_config(ImageDrawConfig)
mut:
	typ BackendType
	begin()
	flush()
	end()
	create_image(string) texture.ITexture
}

// Base Struct
pub struct BaseBackend {
mut:
	typ BackendType = .@none
}

pub fn (mut base_backend BaseBackend) begin() {}

pub fn (mut base_backend BaseBackend) flush() {}

pub fn (mut base_backend BaseBackend) end() {}

pub fn (mut base_backend BaseBackend) create_image(path string) texture.ITexture {
	return &texture.BaseTexture{}
}

pub fn (base_backend &BaseBackend) draw_image_with_config(cfg ImageDrawConfig) {}

pub fn (base_backend &BaseBackend) draw_rect_filled(x f64, y f64, width f64, height f64, color object.GameObjectColor[f64]) {}

pub fn (base_backend &BaseBackend) draw_rect_empty(x f64, y f64, width f64, height f64, color object.GameObjectColor[f64]) {}

pub fn (base_backend &BaseBackend) draw_text(x f64, y f64, text string, config gx.TextCfg) {}

//
// Configs
// TODO: Move this somehwer els
pub enum DrawEffect {
	alpha
	add
}

[args; params]
pub struct ImageDrawConfig {
pub mut:
	texture  texture.ITexture
	position vector.Vector2[f64]
	size     vector.Vector2[f64]
	color    object.GameObjectColor[f64]
	effects  DrawEffect = .alpha
}

//
[args; params]
pub struct DrawConfig {
pub mut:
	backend &IBackend = unsafe { nil }
	scale   f64       = 1.0 // Extra scale
	offset  vector.Vector2[f64] // Offsets
	effects DrawEffect = .alpha
}