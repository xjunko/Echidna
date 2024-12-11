module sample

import beatrice.app
import beatrice.engine
import beatrice.engine.renderer
import beatrice.math.vector
import beatrice.drawable.sprite

pub struct SampleApplication {
	app.Application
mut:
	manager &sprite.Manager = unsafe { nil }
	spr     &sprite.Sprite  = unsafe { nil }

	last_delta f64
}

pub fn SampleApplication.create(mut c_engine engine.Engine) &SampleApplication {
	mut application := &SampleApplication{
		Application: app.Application.create(mut c_engine)
	}

	application.initialize()

	return application
}

pub fn (mut sample_app SampleApplication) initialize() {
	sample_app.manager = sprite.new_manager()

	sample_app.spr = &sprite.Sprite{
		textures:       [
			sample_app.c_engine.resource_manager.load_image('assets/images/teto.png',
				'teto'),
		]
		always_visible: true
	}

	sample_app.spr.position.x = 640
	sample_app.spr.position.y = 360

	sample_app.spr.reset_size_based_on_texture()
	sample_app.spr.reset_attributes_based_on_transforms()

	sample_app.manager.add(mut sample_app.spr)
}

pub fn (mut sample_app SampleApplication) update() {
	sample_app.manager.update(sample_app.c_engine.time.time)
}

pub fn (mut sample_app SampleApplication) draw(mut graphics renderer.IRenderer) {
	// Background
	graphics.set_color(r: 25, g: 25, b: 25)

	// Draw sprites
	// sample_app.manager.draw(mut graphics)

	// Images
	{
		img := sample_app.c_engine.resource_manager.load_image('assets/images/teto.png',
			'teto')

		graphics.draw_image(
			image:    img
			position: vector.Vector2[f64]{100, 100}
			rotation: f32(sample_app.c_engine.time.time) / 10.0
			origin:   vector.centre
		)
	}
	// Text
	{
		mut font := sample_app.c_engine.resource_manager.get_font('Default')

		graphics.draw_rect(vector.Vector2[f64]{100, 100}, vector.Vector2[f64]{200, 50},
			renderer.Color.from_rgb[u8](0, 0, 0))

		graphics.draw_text(font,
			text:     'Hello, World!'
			position: vector.Vector2[f64]{100, 150}
		)

		graphics.draw_text(font,
			text:     'HIIII!!!!!!'
			size:     vector.Vector2[f64]{64, 64}
			position: vector.Vector2[f64]{700, 600}
		)
	}
	// Geometry
	{
		graphics.draw_rect(vector.Vector2[f64]{100, 100}, vector.Vector2[f64]{32, 32},
			renderer.Color.from_rgb[u8](255, 0, 0))

		graphics.draw_rect_outline(vector.Vector2[f64]{640 - 100 / 2, 360 - 64 / 2}, vector.Vector2[f64]{100, 64},
			renderer.Color.from_rgb[u8](255, 255, 255))

		graphics.draw_line(vector.Vector2[f64]{1280, 720}, vector.Vector2[f64]{640, 360},
			renderer.Color.from_rgb[u8](0, 255, 0))
	}
	// FPS
	{
		sample_app.draw_fps(mut graphics)
	}
}

pub fn (mut sample_app SampleApplication) draw_fps(mut graphics renderer.IRenderer) {
	delta_t := sample_app.c_engine.time.delta
	sample_app.last_delta = (sample_app.last_delta * 0.9) + (delta_t * 0.1)
	fps := 1000.0 / sample_app.last_delta

	fps_string := '${int(fps)} fps'
	ms_string := '${sample_app.last_delta:.1f} ms'

	{
		mut font := sample_app.c_engine.resource_manager.get_font('Default')
		mut color := renderer.Color.from_rgb[u8](255, 255, 255)

		if fps < 120 {
			color.b = 0
			color.g = 0
		}

		graphics.draw_text(font,
			text:           fps_string
			color:          color
			align:          .right
			vertical_align: .bottom
			size:           vector.Vector2[f64]{24, 24}
			position:       vector.Vector2[f64]{1280, 720 - 24}
			outline:        true
		)

		graphics.draw_text(font,
			text:           ms_string
			color:          color
			align:          .right
			vertical_align: .bottom
			size:           vector.Vector2[f64]{24, 24}
			position:       vector.Vector2[f64]{1280, 720}
			outline:        true
		)
	}
}
