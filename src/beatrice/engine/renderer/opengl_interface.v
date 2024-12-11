module renderer

import sdl
import sokol
import sokol.sgl
import sokol.gfx
import sokol.sapp
import beatrice.math.vector
import beatrice.engine.resource

pub struct OpenGLPipeline {
pub mut:
	alpha sgl.Pipeline
	add   sgl.Pipeline
}

fn (mut gl_pipeline OpenGLPipeline) initialize() {
	// FIXME(FireRedz): this looks kinda funny, find a better way to initialize pipeline.

	// Alpha
	mut alpha_pipdesc := gfx.PipelineDesc{}
	unsafe { vmemset(&alpha_pipdesc, 0, int(sizeof(alpha_pipdesc))) }
	alpha_pipdesc.label = c'alpha-pipeline'
	alpha_pipdesc.colors[0] = gfx.ColorTargetState{
		blend: gfx.BlendState{
			enabled:        true
			src_factor_rgb: .src_alpha
			dst_factor_rgb: .one_minus_src_alpha
		}
	}
	gl_pipeline.alpha = sgl.make_pipeline(&alpha_pipdesc)

	// Add
	mut add_pipdesc := gfx.PipelineDesc{}
	unsafe { vmemset(&add_pipdesc, 0, int(sizeof(add_pipdesc))) }
	add_pipdesc.label = c'additive-pipeline'
	add_pipdesc.colors[0] = gfx.ColorTargetState{
		blend: gfx.BlendState{
			enabled:        true
			src_factor_rgb: .src_alpha
			dst_factor_rgb: .one
		}
	}
	gl_pipeline.add = sgl.make_pipeline(&add_pipdesc)
}

pub struct OpenGLGraphic {
mut:
	window &sdl.Window = unsafe { nil }

	in_scene     bool
	antialiasing bool

	pass     gfx.Pass
	pipeline &OpenGLPipeline = unsafe { nil }
}

pub fn glue_environment() gfx.Environment {
	mut env := gfx.Environment{}
	unsafe { vmemset(&env, 0, int(sizeof(env))) }
	env.defaults.color_format = .rgba8
	env.defaults.depth_format = .@none
	env.defaults.sample_count = 4
	return env
}

pub fn glue_swapchain() gfx.Swapchain {
	mut swapchain := gfx.Swapchain{}
	unsafe { vmemset(&swapchain, 0, int(sizeof(swapchain))) }
	swapchain.width = 1280
	swapchain.height = 720
	swapchain.sample_count = 4
	swapchain.color_format = .rgba8
	swapchain.depth_format = .@none
	swapchain.gl.framebuffer = 0 // use default framebuffer (usually 0)
	return swapchain
}

pub fn (mut gl_graphic OpenGLGraphic) initialize() {
	// setup sokol-gfx
	desc := gfx.Desc{
		environment: glue_environment()
	}

	gfx.setup(&desc)
	assert gfx.is_valid() == true

	// setup sokol-sgl
	sgl_desc := sgl.Desc{}
	sgl.setup(&sgl_desc)

	// pass-action
	mut action := gfx.create_clear_pass_action(0.0, 0.0, 0.0, 1.0)
	gl_graphic.pass = gfx.Pass{
		action:    action
		swapchain: glue_swapchain()
	}

	// pipelines
	gl_graphic.pipeline = &OpenGLPipeline{}
	gl_graphic.pipeline.initialize()
}

pub fn OpenGLGraphic.create(window &sdl.Window) &OpenGLGraphic {
	mut gl_graphic := &OpenGLGraphic{
		window: unsafe { window }
	}

	gl_graphic.initialize()

	return gl_graphic
}

pub fn (mut gl_graphic OpenGLGraphic) begin() {
	gfx.begin_pass(&gl_graphic.pass)
	sgl.defaults()
	sgl.matrix_mode_projection()
	sgl.ortho(0.0, 1280, 720, 0.0, -1.0, 1.0)
}

pub fn (mut gl_graphic OpenGLGraphic) end() {
	sgl.draw()
	gfx.end_pass()
	gfx.commit()
	sdl.gl_swap_window(gl_graphic.window)
}

pub fn (mut gl_graphic OpenGLGraphic) draw_pixel(position vector.Vector2[f64], color Color[u8], size f64) {
	sgl.begin_points()
	{
		sgl.c4b(color.r, color.g, color.b, color.a)
		sgl.point_size(f32(size))
		sgl.v2f(f32(position.x), f32(position.y))
	}
	sgl.end()
}

pub fn (mut gl_graphic OpenGLGraphic) draw_line(start vector.Vector2[f64], end vector.Vector2[f64], color Color[u8]) {
	sgl.begin_line_strip()
	{
		sgl.c4b(color.r, color.g, color.b, color.a)
		sgl.v2f(f32(start.x), f32(start.y))
		sgl.v2f(f32(end.x), f32(end.y))
	}
	sgl.end()
}

pub fn (mut gl_graphic OpenGLGraphic) draw_rect_outline(position vector.Vector2[f64], size vector.Vector2[f64], color Color[u8]) {
	sgl.begin_line_strip()
	{
		sgl.c4b(color.r, color.g, color.b, color.a)
		sgl.v2f(f32(position.x), f32(position.y))
		sgl.v2f(f32(position.x + size.x), f32(position.y))
		sgl.v2f(f32(position.x + size.x), f32(position.y + size.y))
		sgl.v2f(f32(position.x), f32(position.y + size.y))
		sgl.v2f(f32(position.x), f32(position.y - 1))
	}
	sgl.end()
}

pub fn (mut gl_graphic OpenGLGraphic) draw_rect(position vector.Vector2[f64], size vector.Vector2[f64], color Color[u8]) {
	sgl.begin_quads()
	{
		sgl.c4b(color.r, color.g, color.b, color.a)
		sgl.v2f(f32(position.x), f32(position.y))
		sgl.v2f(f32(position.x + size.x), f32(position.y))
		sgl.v2f(f32(position.x + size.x), f32(position.y + size.y))
		sgl.v2f(f32(position.x), f32(position.y + size.y))
	}
	sgl.end()
}

// Refer to V's gg for the original implementation of this function
pub fn (mut gl_graphic OpenGLGraphic) draw_image(args &ImageDrawParameter) {
	gl_img := args.image as OpenGLImage
	rotation := args.rotation != 0.0

	mut image_pos := unsafe { &args.position }
	mut image_size := unsafe { &args.size }

	if image_size.x == 0 && image_size.y == 0 {
		image_size.x = f32(gl_img.width)
		image_size.y = f32(gl_img.height)
	}

	u0 := f32(0.0)
	v0 := f32(0.0)

	u1 := f32(1.0)
	v1 := f32(1.0)

	mut x0 := f32(image_pos.x)
	mut y0 := f32(image_pos.y)

	mut x1 := f32(image_pos.x + image_size.x)
	mut y1 := f32(image_pos.y + image_size.y)

	if image_size.y == 0 {
		scale := gl_img.width / f32(image_size.x)
		y1 = f32(image_pos.y) + (f32(gl_img.height) / scale)
	}

	sgl.load_pipeline(gl_graphic.pipeline.alpha)
	sgl.enable_texture()
	sgl.texture(gl_img.s_image, gl_img.s_sampler)

	if rotation {
		width := f32(image_size.x)
		height := f32(image_size.y)

		sgl.push_matrix()

		match args.origin.typ {
			// TOP
			.top_left {
				sgl.translate(x0, y0, 0)
				sgl.rotate(sgl.rad(f32(args.rotation)), 0, 0, 1)
				sgl.translate(-x0, -y0, 0)
			}
			.top_centre {
				sgl.translate(x0 + (width / 2), y0 - height, 0)
				sgl.rotate(sgl.rad(f32(args.rotation)), 0, 0, 1)
				sgl.translate(-x0 - (width / 2), -y0, 0)
			}
			.top_right {
				sgl.translate(x0 + width, y0 - height, 0)
				sgl.rotate(sgl.rad(f32(args.rotation)), 0, 0, 1)
				sgl.translate(-x0 - width, -y0, 0)
			}
			// CENTRE
			.centre_left {
				sgl.translate(x0, y0 + (height / 2), 0)
				sgl.rotate(sgl.rad(f32(args.rotation)), 0, 0, 1)
				sgl.translate(-x0, -y0 - (height / 2), 0)
			}
			.centre {
				sgl.translate(x0 + (width / 2), y0 + (height / 2), 0)
				sgl.rotate(sgl.rad(f32(args.rotation)), 0, 0, 1)
				sgl.translate(-x0 - (width / 2), -y0 - (height / 2), 0)
			}
			.centre_right {
				sgl.translate(x0 + width, y0 + (height / 2), 0)
				sgl.rotate(sgl.rad(f32(args.rotation)), 0, 0, 1)
				sgl.translate(-x0 - width, -y0 - (height / 2), 0)
			}
			// BOTTOM
			.bottom_left {
				sgl.translate(x0, y0 + height, 0)
				sgl.rotate(sgl.rad(f32(args.rotation)), 0, 0, 1)
				sgl.translate(-x0, -y0 - height, 0)
			}
			.bottom_centre {
				sgl.translate(x0 + (width / 2), y0 + height, 0)
				sgl.rotate(sgl.rad(f32(args.rotation)), 0, 0, 1)
				sgl.translate(-x0 - (width / 2), -y0 - height, 0)
			}
			.bottom_right {
				sgl.translate(x0 + width, y0 + height, 0)
				sgl.rotate(sgl.rad(f32(args.rotation)), 0, 0, 1)
				sgl.translate(-x0 - width, -y0 - height, 0)
			}
		}
	}

	sgl.begin_quads()
	sgl.c4b(u8(args.color.r), u8(args.color.g), u8(args.color.b), u8(args.color.a))
	{
		sgl.v3f_t2f(x0, y0, 0, u0, v0)
		sgl.v3f_t2f(x1, y0, 0, u1, v0)
		sgl.v3f_t2f(x1, y1, 0, u1, v1)
		sgl.v3f_t2f(x0, y1, 0, u0, v1)
	}
	sgl.end()

	if rotation {
		sgl.pop_matrix()
	}

	sgl.disable_texture()
}

pub fn (mut gl_graphic OpenGLGraphic) set_bg_color(color ColorU8) {
	gl_graphic.pass = gfx.Pass{
		action:    gfx.create_clear_pass_action(color.r, color.g, color.b, 1.0)
		swapchain: glue_swapchain()
	}
}

pub fn (mut gl_graphic OpenGLGraphic) set_color(color ColorU8) {
	sgl.begin_quads()
	{
		sgl.c3b(color.r, color.g, color.b)
		sgl.v2f(0, 0)
		sgl.v2f(1280, 0)
		sgl.v2f(1280, 720)
		sgl.v2f(0, 720)
	}
	sgl.end()
}

pub fn (mut gl_graphic OpenGLGraphic) set_vsync(vsync bool) {
	sdl.gl_set_swap_interval(int(vsync))
}

pub fn (mut gl_graphic OpenGLGraphic) create_image(path string, mipmapped bool, keep_in_mem bool) &resource.Image {
	return OpenGLImage.create(path, mipmapped, keep_in_mem)
}
