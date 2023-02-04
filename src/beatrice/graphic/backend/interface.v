module backend

import gx
import beatrice.component.object
import beatrice.graphic.texture
import beatrice.math.vector

// Types
pub enum BackendType {
	@none
	gg
	sdl
}

// Interface

[heap]
pub interface IBackend {
	// FNs that doesnt need to be mutable
	draw_rect_filled(f64, f64, f64, f64, object.GameObjectColor[f64])
	draw_rect_empty(f64, f64, f64, f64, object.GameObjectColor[f64])
	draw_text(f64, f64, string, gx.TextCfg)
	draw_image_with_config(ImageDrawConfig)
	text_width(string) int
	text_height(string) int
mut:
	typ BackendType
	begin()
	flush()
	end()
	create_image(string) texture.ITexture
}

// Base Struct
[heap]
pub struct BaseBackend {
pub mut:
	typ BackendType = .@none
}

pub fn (mut base_backend BaseBackend) begin() {
	println('[Warning] Unimplemented ${@METHOD}')
}

pub fn (mut base_backend BaseBackend) flush() {
	println('[Warning] Unimplemented ${@METHOD}')
}

pub fn (mut base_backend BaseBackend) end() {
	println('[Warning] Unimplemented ${@METHOD}')
}

pub fn (mut base_backend BaseBackend) create_image(path string) texture.ITexture {
	println('[Warning] Unimplemented ${@METHOD}')
	return &texture.BaseTexture{}
}

pub fn (base_backend &BaseBackend) draw_image_with_config(cfg ImageDrawConfig) {
	println('[Warning] Unimplemented ${@METHOD}')
}

pub fn (base_backend &BaseBackend) draw_rect_filled(x f64, y f64, width f64, height f64, color object.GameObjectColor[f64]) {
	println('[Warning] Unimplemented ${@METHOD}')
}

pub fn (base_backend &BaseBackend) draw_rect_empty(x f64, y f64, width f64, height f64, color object.GameObjectColor[f64]) {
	println('[Warning] Unimplemented ${@METHOD}')
}

pub fn (base_backend &BaseBackend) draw_text(x f64, y f64, text string, config gx.TextCfg) {
	println('[Warning] Unimplemented ${@METHOD}')
}

pub fn (base_backend &BaseBackend) text_width(text string) int {
	println('[Warning] Unimplemented ${@METHOD}')
	return -1
}

pub fn (base_backend &BaseBackend) text_height(text string) int {
	println('[Warning] Unimplemented ${@METHOD}')
	return -1
}

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
	origin   vector.Origin = vector.centre
	size     vector.Vector2[f64]
	color    object.GameObjectColor[f64]
	effects  DrawEffect = .alpha
	z_index  int
	angle    f64
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
