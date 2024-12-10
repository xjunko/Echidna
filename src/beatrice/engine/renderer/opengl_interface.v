module renderer

import sdl
import sokol
import sokol.sgl
import sokol.gfx
import sokol.sapp
import beatrice.math.vector

pub struct OpenGLGraphic {
mut:
	window &sdl.Window = unsafe { nil }

	in_scene     bool
	antialiasing bool

	pass gfx.Pass
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

pub fn (mut gl_graphic OpenGLGraphic) draw_pixel(position vector.Vector2[f32], color Color[u8], size f32) {
	sgl.begin_points()
	{
		sgl.c4b(color.r, color.g, color.b, color.a)
		sgl.point_size(size)
		sgl.v2f(position.x, position.y)
	}
	sgl.end()
}

pub fn (mut gl_graphic OpenGLGraphic) draw_line(start vector.Vector2[f32], end vector.Vector2[f32], color Color[u8]) {
	sgl.begin_line_strip()
	{
		sgl.c4b(color.r, color.g, color.b, color.a)
		sgl.v2f(start.x, start.y)
		sgl.v2f(end.x, end.y)
	}
	sgl.end()
}

pub fn (mut gl_graphic OpenGLGraphic) draw_rect_outline(position vector.Vector2[f32], size vector.Vector2[f32], color Color[u8]) {
	sgl.begin_line_strip()
	{
		sgl.c4b(color.r, color.g, color.b, color.a)
		sgl.v2f(position.x, position.y)
		sgl.v2f(position.x + size.x, position.y)
		sgl.v2f(position.x + size.x, position.y + size.y)
		sgl.v2f(position.x, position.y + size.y)
		sgl.v2f(position.x, position.y - 1)
	}
	sgl.end()
}

pub fn (mut gl_graphic OpenGLGraphic) draw_rect(position vector.Vector2[f32], size vector.Vector2[f32], color Color[u8]) {
	sgl.begin_quads()
	{
		sgl.c4b(color.r, color.g, color.b, color.a)
		sgl.v2f(position.x, position.y)
		sgl.v2f(position.x + size.x, position.y)
		sgl.v2f(position.x + size.x, position.y + size.y)
		sgl.v2f(position.x, position.y + size.y)
	}
	sgl.end()
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
