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

pub enum TextAlignmentHorizontal {
	left   = C.FONS_ALIGN_LEFT
	center = C.FONS_ALIGN_CENTER
	right  = C.FONS_ALIGN_RIGHT
}

pub enum TextAlignmentVertical {
	top      = C.FONS_ALIGN_TOP
	middle   = C.FONS_ALIGN_MIDDLE
	bottom   = C.FONS_ALIGN_BOTTOM
	baseline = C.FONS_ALIGN_BASELINE
}

@[args; params]
pub struct TextDrawParams {
pub mut:
	text           string @[required]
	position       vector.Vector2[f64]
	size           vector.Vector2[f64]     = vector.Vector2[f64]{c_default_font_size, c_default_font_size}
	font_name      string                  = c_default_font
	color          renderer.Color[u8]      = renderer.Color.from_rgb[u8](255, 255, 255)
	vertical_align TextAlignmentVertical   = TextAlignmentVertical.top
	align          TextAlignmentHorizontal = TextAlignmentHorizontal.left

	shadow  bool
	outline bool
}

pub fn (mut fonts Fonts) draw_text(mut graphics renderer.IRenderer, args TextDrawParams) {
	fonts.fons.set_size(f32(1.0 * args.size.x))
	fonts.fons.set_font(fonts.fonts[args.font_name].id)

	if args.shadow {
		fonts.fons.set_color(sfons.rgba(0, 0, 0, 255))
		fonts.fons.set_spacing(0.0)
		fonts.fons.set_blur(3.0)
		fonts.fons.draw_text(f32(args.position.x), f32(args.position.y + 2), args.text)
		fonts.fons.set_blur(0.0)
	}

	if args.outline {
		fonts.fons.set_color(sfons.rgba(0, 0, 0, 255))
		fonts.fons.set_spacing(0.0)
		fonts.fons.set_blur(0.0)
		fonts.fons.draw_text(f32(args.position.x - 1), f32(args.position.y), args.text)
		fonts.fons.draw_text(f32(args.position.x + 1), f32(args.position.y), args.text)
		fonts.fons.draw_text(f32(args.position.x), f32(args.position.y - 1), args.text)
		fonts.fons.draw_text(f32(args.position.x), f32(args.position.y + 1), args.text)
		fonts.fons.set_blur(0.0)
	}

	fonts.fons.set_color(sfons.rgba(args.color.r, args.color.g, args.color.b, args.color.a))
	fonts.fons.set_align(int(args.align) | int(args.vertical_align))

	fonts.fons.draw_text(f32(args.position.x), f32(args.position.y), args.text)
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
