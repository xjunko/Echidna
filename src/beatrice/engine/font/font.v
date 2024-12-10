module font

import os
import fontstash
import sokol.sfons
import beatrice.math.vector
import beatrice.engine.renderer

const c_fonts = {
	'Tahoma': Font{
		name: 'Tahoma'
		path: 'assets/fonts/tahoma.ttf'
	}
}

const c_default_font = 'Tahoma'
const c_default_font_size = 32.0

pub struct Font {
pub mut:
	id   int
	name string
	path string
}

pub struct Fonts {
mut:
	fons &fontstash.Context = unsafe { nil }
pub mut:
	fonts map[string]Font
}

pub fn (mut fonts Fonts) load_font(font Font) {
	fonts.fonts[font.name] = Font{
		name: font.name
		path: font.path
	}

	font_bytes := os.read_bytes(font.path) or { panic(err) }
	fonts.fonts[font.name].id = fonts.fons.add_font_mem(font.name, font_bytes, true)

	unsafe {
		font_bytes.free()
	}
}

@[args; params]
pub struct TextDrawParams {
pub mut:
	text      string @[required]
	position  vector.Vector2[f32]
	size      vector.Vector2[f32] = vector.Vector2[f32]{c_default_font_size, c_default_font_size}
	font_name string              = c_default_font
	r         u8                  = 255
	g         u8                  = 255
	b         u8                  = 255
	align     int
}

pub fn (mut fonts Fonts) draw_text(mut graphics renderer.IRenderer, args TextDrawParams) {
	fonts.fons.set_font(fonts.fonts[args.font_name].id)
	fonts.fons.set_size(1.0 * args.size.x)
	fonts.fons.set_align(0)
	fonts.fons.set_color(sfons.rgba(args.r, args.g, args.b, 255))
	fonts.fons.draw_text(100, 100, args.text)
}

pub fn (mut fonts Fonts) flush() {
	sfons.flush(fonts.fons)
}

pub fn Fonts.create() &Fonts {
	mut fonts := &Fonts{}

	fonts.fons = sfons.create(512, 512, 1)
	fonts.load_font(c_fonts[c_default_font])

	return fonts
}
