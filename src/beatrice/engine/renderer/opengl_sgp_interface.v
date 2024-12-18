module renderer

import sdl
import thirdparty.sokol.sgl
import thirdparty.sokol.gfx
import thirdparty.sokol.gp
import beatrice.util.math.vector
import beatrice.engine.font
import beatrice.engine.resource

pub struct SokolGPGraphic {
	OpenGLGraphic
}

pub fn (mut gp_graphic SokolGPGraphic) initialize() {
	gp_graphic.OpenGLGraphic.initialize()

	// Initialize sokol_gp
	sgp_desc := gp.Desc{}
	gp.setup(&sgp_desc)

	if !gp.is_valid() {
		panic('Failed to initialize sokol_gp')
	}
}

pub fn SokolGPGraphic.create(window &sdl.Window) &SokolGPGraphic {
	mut gp_graphic := &SokolGPGraphic{
		OpenGLGraphic: OpenGLGraphic.create(window)
	}

	gp_graphic.initialize()

	return gp_graphic
}

pub fn (mut gp_graphic SokolGPGraphic) begin() {
	gp_graphic.OpenGLGraphic.begin()

	gp.begin(gp_graphic.resolution.x, gp_graphic.resolution.y)
	gp.viewport(0, 0, gp_graphic.resolution.x, gp_graphic.resolution.y)
}

pub fn (mut gp_graphic SokolGPGraphic) end() {
	gp.flush()
	gp.end()
	gp_graphic.OpenGLGraphic.end()
}

pub fn (mut gp_graphic SokolGPGraphic) push_matrix() {
	gp.push_transform()
}

pub fn (mut gp_graphic SokolGPGraphic) pop_matrix() {
	gp.pop_transform()
}

pub fn (mut gp_graphic SokolGPGraphic) translate(x f32, y f32, z f32) {
	gp.translate(x, y)
}

pub fn (mut gp_graphic SokolGPGraphic) rotate(angle f32) {
	gp.rotate(angle)
}

pub fn (mut gp_graphic SokolGPGraphic) draw_line(start vector.Vector2[f64], end vector.Vector2[f64], color Color[u8]) {
	gp.set_color(color.r, color.g, color.b, color.a)
	gp.draw_line(f32(start.x), f32(start.y), f32(end.x), f32(end.y))
}

pub fn (mut gp_graphic SokolGPGraphic) draw_rect(position vector.Vector2[f64], size vector.Vector2[f64], color Color[u8]) {
	gp.set_color(color.r, color.g, color.b, color.a)
	gp.draw_filled_rect(f32(position.x), f32(position.y), f32(size.x), f32(size.y))
}

pub fn (mut gp_graphic SokolGPGraphic) create_image(path string, mipmapped bool, keep_in_mem bool) &resource.Image {
	return OpenGLImage.create_from_path(path, mipmapped, keep_in_mem)
}

// Refer to V's gg for the original implementation of this function
pub fn (mut gp_graphic SokolGPGraphic) draw_image(args &ImageDrawParameter) {
	gl_img := args.image as OpenGLImage

	rotation := args.rotation != 0.0

	mut image_pos := unsafe { &args.position }
	mut image_size := unsafe { &args.size }

	if image_size.x == 0 && image_size.y == 0 {
		image_size.x = f32(gl_img.width)
		image_size.y = f32(gl_img.height)
	}

	mut x0 := f32(image_pos.x)
	mut y0 := f32(image_pos.y)

	mut w := f32(image_size.x)
	mut h := f32(image_size.y)

	gp.set_blend_mode(.blend)

	if rotation {
		width := f32(image_size.x)
		height := f32(image_size.y)

		gp.push_transform()

		match args.origin.typ {
			// TOP
			.top_left {
				gp_graphic.translate(x0, y0, 0)
				gp_graphic.rotate(sgl.rad(f32(args.rotation)))
				gp_graphic.translate(-x0, -y0, 0)
			}
			.top_centre {
				gp_graphic.translate(x0 + (width / 2), y0 - height, 0)
				gp_graphic.rotate(sgl.rad(f32(args.rotation)))
				gp_graphic.translate(-x0 - (width / 2), -y0, 0)
			}
			.top_right {
				gp_graphic.translate(x0 + width, y0 - height, 0)
				gp_graphic.rotate(sgl.rad(f32(args.rotation)))
				gp_graphic.translate(-x0 - width, -y0, 0)
			}
			// CENTRE
			.centre_left {
				gp_graphic.translate(x0, y0 + (height / 2), 0)
				gp_graphic.rotate(sgl.rad(f32(args.rotation)))
				gp_graphic.translate(-x0, -y0 - (height / 2), 0)
			}
			.centre {
				gp_graphic.translate(x0 + (width / 2), y0 + (height / 2), 0)
				gp_graphic.rotate(sgl.rad(f32(args.rotation)))
				gp_graphic.translate(-x0 - (width / 2), -y0 - (height / 2), 0)
			}
			.centre_right {
				gp_graphic.translate(x0 + width, y0 + (height / 2), 0)
				gp_graphic.rotate(sgl.rad(f32(args.rotation)))
				gp_graphic.translate(-x0 - width, -y0 - (height / 2), 0)
			}
			// BOTTOM
			.bottom_left {
				gp_graphic.translate(x0, y0 + height, 0)
				gp_graphic.rotate(sgl.rad(f32(args.rotation)))
				gp_graphic.translate(-x0, -y0 - height, 0)
			}
			.bottom_centre {
				gp_graphic.translate(x0 + (width / 2), y0 + height, 0)
				gp_graphic.rotate(sgl.rad(f32(args.rotation)))
				gp_graphic.translate(-x0 - (width / 2), -y0 - height, 0)
			}
			.bottom_right {
				gp_graphic.translate(x0 + width, y0 + height, 0)
				gp_graphic.rotate(sgl.rad(f32(args.rotation)))
				gp_graphic.translate(-x0 - width, -y0 - height, 0)
			}
		}
	}

	gp.set_image(0, gl_img.s_image)
	gp.set_sampler(0, gp_graphic.common_img_sampler)

	gp.set_color(f32(args.color.r), f32(args.color.g), f32(args.color.b), f32(args.color.a))
	gp.draw_filled_rect(x0, y0, w, h)

	gp.unset_image(0)
	gp.reset_sampler(0)

	if rotation {
		gp.pop_transform()
	}
}

pub fn (mut gp_graphic SokolGPGraphic) draw_text(c_font &font.Font, arg font.TextDrawParams) {
	if isnil(c_font) {
		return
	}

	unsafe { c_font.draw(arg) }
}
