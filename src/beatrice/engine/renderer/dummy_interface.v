module renderer

import beatrice.math.vector

pub type ColorU8 = Color[u8]

pub struct Color[T] {
pub mut:
	r T
	g T
	b T
	a T
}

pub fn Color.from_rgb[T](r T, g T, b T) Color[T] {
	return Color[T]{
		r: r
		g: g
		b: b
		a: T(255)
	}
}

pub fn Color.from_rgba[T](r T, g T, b T, a T) Color[T] {
	return Color[T]{
		r: r
		g: g
		b: b
		a: a
	}
}

pub interface IRenderer {
mut:
	initialize()

	begin()
	end()

	draw_pixel(vector.Vector2[f32], Color[u8], f32)
	draw_line(vector.Vector2[f32], vector.Vector2[f32], Color[u8])
	draw_rect_outline(vector.Vector2[f32], vector.Vector2[f32], Color[u8])
	draw_rect(vector.Vector2[f32], vector.Vector2[f32], Color[u8])

	set_bg_color(ColorU8)
	set_color(ColorU8)
}
