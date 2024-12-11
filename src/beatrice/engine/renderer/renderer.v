module renderer

import beatrice.math.vector
import beatrice.engine.resource

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

@[args; params]
pub struct ImageDrawParameter {
pub mut:
	image    &resource.Image     @[required]
	position vector.Vector2[f64] @[required]
	size     vector.Vector2[f64]
	color    Color[f64]    = Color.from_rgba[f64](255, 255, 255, 255)
	origin   vector.Origin = vector.centre
	rotation f64
}

pub interface IRenderer {
mut:
	initialize()

	begin()
	end()

	draw_pixel(vector.Vector2[f64], Color[u8], f64)
	draw_line(vector.Vector2[f64], vector.Vector2[f64], Color[u8])
	draw_rect_outline(vector.Vector2[f64], vector.Vector2[f64], Color[u8])
	draw_rect(vector.Vector2[f64], vector.Vector2[f64], Color[u8])

	set_bg_color(ColorU8)
	set_color(ColorU8)

	set_vsync(bool)

	create_image(string, bool, bool) &resource.Image
	draw_image(&ImageDrawParameter)
}
