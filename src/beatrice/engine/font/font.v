module font

import os
import fontstash
import thirdparty.sokol.sfons
import beatrice.util.math.vector

const c_fonts = {
	'Tahoma': Font{
		name: 'Default'
		path: 'assets/fonts/tahoma.ttf'
	}
}

const c_default_font = 'Tahoma'
const c_default_font_size = 32.0

pub struct Font {
mut:
	fons &fontstash.Context = unsafe { nil }
pub mut:
	id   int
	name string
	path string
}

pub fn (mut font Font) initialize() {
	font_bytes := os.read_bytes(font.path) or { panic(err) }
	font.id = font.fons.add_font_mem(font.name, font_bytes, true)

	unsafe {
		font_bytes.free()
	}
}

pub fn (mut font Font) flush() {
	sfons.flush(font.fons)
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

pub interface IColor[T] {
mut:
	r T
	g T
	b T
	a T
}

pub struct FontColor[T] {
pub mut:
	r T
	g T
	b T
	a T
}

@[args; params]
pub struct TextDrawParams {
pub mut:
	text           string @[required]
	position       vector.Vector2[f64]
	size           vector.Vector2[f64]     = vector.Vector2[f64]{c_default_font_size, c_default_font_size}
	font_name      string                  = c_default_font
	color          IColor[u8]              = FontColor[u8]{255, 255, 255, 255}
	vertical_align TextAlignmentVertical   = TextAlignmentVertical.top
	align          TextAlignmentHorizontal = TextAlignmentHorizontal.left

	shadow  bool
	outline bool
}

pub fn (mut font Font) draw(args TextDrawParams) {
	font.fons.set_size(f32(1.0 * args.size.x))
	font.fons.set_font(font.id)

	if args.shadow {
		font.fons.set_color(sfons.rgba(0, 0, 0, 255))
		font.fons.set_spacing(0.0)
		font.fons.set_blur(3.0)
		font.fons.draw_text(f32(args.position.x), f32(args.position.y + 2), args.text)
		font.fons.set_blur(0.0)
	}

	if args.outline {
		font.fons.set_color(sfons.rgba(0, 0, 0, 255))
		font.fons.set_spacing(0.0)
		font.fons.set_blur(0.0)
		font.fons.draw_text(f32(args.position.x - 1), f32(args.position.y), args.text)
		font.fons.draw_text(f32(args.position.x + 1), f32(args.position.y), args.text)
		font.fons.draw_text(f32(args.position.x), f32(args.position.y - 1), args.text)
		font.fons.draw_text(f32(args.position.x), f32(args.position.y + 1), args.text)
		font.fons.set_blur(0.0)
	}

	font.fons.set_color(sfons.rgba(args.color.r, args.color.g, args.color.b, args.color.a))
	font.fons.set_align(int(args.align) | int(args.vertical_align))

	font.fons.draw_text(f32(args.position.x), f32(args.position.y), args.text)
}

pub fn Font.create(name string, path string, fons &fontstash.Context) &Font {
	mut font := &Font{
		name: name
		path: path
		fons: unsafe { fons }
	}

	font.initialize()

	return font
}

pub struct Fonts {
mut:
	fons &fontstash.Context = unsafe { nil }
pub mut:
	fonts map[string]&Font
}

pub fn (mut fonts Fonts) load_font(name string, path string) &Font {
	if name !in fonts.fonts {
		fonts.fonts[name] = Font.create(name, path, fonts.fons)
	}

	return unsafe { fonts.fonts[name] }
}

pub fn (mut fonts Fonts) get_font(name string) &Font {
	if font := fonts.fonts[name] {
		return font
	}

	return unsafe { fonts.fonts[c_default_font] }
}

pub fn (mut fonts Fonts) flush() {
	sfons.flush(fonts.fons)
}

pub fn Fonts.create() &Fonts {
	mut fonts := &Fonts{}

	fonts.fons = sfons.create(512, 512, 1)

	unsafe {
		default_font := c_fonts[c_default_font]
		fonts.load_font(default_font.name, default_font.path)
	}
	return fonts
}
