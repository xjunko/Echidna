module backend

import gx
import sdl
import sdl.ttf
import sdl.image
import beatrice.component.object
import beatrice.graphic.texture

pub struct SDLBackend {
	BaseBackend
mut:
	cache map[string]&SDLTexture

	window   &sdl.Window   = unsafe { nil }
	renderer &sdl.Renderer = unsafe { nil }
	surface  &sdl.Surface  = unsafe { nil }
	font     &ttf.Font     = unsafe { nil }
}

// OPs
pub fn (sdl_backend &SDLBackend) begin() {
	sdl.render_clear(sdl_backend.renderer)
}

pub fn (sdl_backend &SDLBackend) end() {
	sdl.render_present(sdl_backend.renderer)
}

// Utils
pub fn (sdl_backend &SDLBackend) get_text_size(text string) []int {
	// Get text size
	w, h := 0, 0
	ttf.size_text(sdl_backend.font, text.str, &w, &h)

	return [w, h]
}

pub fn (sdl_backend &SDLBackend) text_width(text string) int {
	return sdl_backend.get_text_size(text)[0]
}

pub fn (sdl_backend &SDLBackend) text_height(text string) int {
	return sdl_backend.get_text_size(text)[1]
}

// Draw
pub fn (sdl_backend &SDLBackend) draw_rect_filled(x f64, y f64, width f64, height f64, color object.GameObjectColor[f64]) {
	sdl.set_render_draw_color(sdl_backend.renderer, u8(color.r), u8(color.g), u8(color.b),
		u8(color.a))
	sdl.render_fill_rect(sdl_backend.renderer, sdl.Rect{
		x: int(x)
		y: int(y)
		w: int(width)
		h: int(height)
	})
}

pub fn (sdl_backend &SDLBackend) draw_rect_empty(x f64, y f64, width f64, height f64, color object.GameObjectColor[f64]) {
	sdl.set_render_draw_color(sdl_backend.renderer, u8(color.r), u8(color.g), u8(color.b),
		u8(color.a))
	sdl.render_draw_rect(sdl_backend.renderer, sdl.Rect{
		x: int(x)
		y: int(y)
		w: int(width)
		h: int(height)
	})
}

pub fn (sdl_backend &SDLBackend) draw_text(x f64, y f64, text string, config gx.TextCfg) {
	font := ttf.open_font('assets/font.ttf'.str, int(config.size / 2))

	// Get text size
	w, h := 0, 0
	ttf.size_text(font, text.str, &w, &h)

	// Apply alignment
	mut pos_x := x
	mut pos_y := y

	match config.align {
		.center {
			pos_x -= w / 2
		}
		.right {
			pos_x += w
		}
		else {}
	}

	if font == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Could not create SDL font, SDL says:\n${error_msg}')
	}

	font_color := sdl.Color{config.color.r, config.color.g, config.color.b, config.color.a}

	surface_message := ttf.render_text_blended(font, text.str, font_color)
	message := sdl.create_texture_from_surface(sdl_backend.renderer, surface_message)

	message_rect := sdl.Rect{int(pos_x), int(pos_y), surface_message.w, surface_message.h}

	sdl.render_copy(sdl_backend.renderer, message, sdl.null, &message_rect)
	sdl.free_surface(surface_message)
	sdl.destroy_texture(message)
	ttf.close_font(font)
}

// Image
pub struct SDLTexture {
mut:
	texture &sdl.Texture
pub mut:
	id     int
	width  int
	height int
}

pub fn (mut sdl_backend SDLBackend) create_image(path string) texture.ITexture {
	if path.to_lower() !in sdl_backend.cache {
		texture := image.load_texture(sdl_backend.renderer, path.str)

		w, h := 0, 0
		sdl.query_texture(texture, sdl.null, sdl.null, &w, &h)

		sdl_backend.cache[path.to_lower()] = &SDLTexture{
			texture: texture
			width: w
			height: h
		}
	}

	return unsafe { sdl_backend.cache[path.to_lower()] }
}

pub fn (sdl_backend &SDLBackend) draw_image_with_config(config ImageDrawConfig) {
	mut texture := unsafe { &config.texture }

	if mut texture is SDLTexture {
		sdl.set_texture_alpha_mod(texture.texture, u8(config.color.a))
		sdl.render_copy(sdl_backend.renderer, texture.texture, sdl.null, sdl.Rect{
			x: int(config.position.x)
			y: int(config.position.y)
			w: int(config.size.x)
			h: int(config.size.y)
		})
	}
}
