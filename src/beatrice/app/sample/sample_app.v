module sample

import beatrice.math.vector
import beatrice.app
import beatrice.engine
import beatrice.engine.font
import beatrice.engine.input
import beatrice.engine.renderer

pub struct SampleApplication {
	app.Application
mut:
	fonts &font.Fonts = unsafe { nil }
}

pub fn SampleApplication.create(mut c_engine engine.Engine) &SampleApplication {
	mut application := &SampleApplication{
		Application: app.Application.create(mut c_engine)
	}

	application.initialize()

	return application
}

pub fn (mut sample_app SampleApplication) initialize() {
	sample_app.fonts = font.Fonts.create()
}

pub fn (mut sample_app SampleApplication) draw(mut graphics renderer.IRenderer) {
	sample_app.fonts.flush()

	// Background
	graphics.set_color(r: 25, g: 25, b: 25)

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
		graphics.draw_rect(vector.Vector2[f64]{100, 100}, vector.Vector2[f64]{200, 50},
			renderer.Color.from_rgb[u8](0, 0, 0))
		sample_app.fonts.draw_text(mut graphics,
			text:     'Hello, World!'
			r:        255
			g:        255
			b:        255
			position: vector.Vector2[f64]{100, 150}
		)

		sample_app.fonts.draw_text(mut graphics,
			text:     'HIIII!!!!!!'
			r:        255
			g:        255
			b:        255
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
}

pub fn (mut sample_app SampleApplication) on_key_down(ev &input.KeyboardEvent) {
	println(ev)
}
