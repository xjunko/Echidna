module sample

import beatrice.app
import beatrice.engine.font
import beatrice.engine.input
import beatrice.engine.renderer

pub struct SampleApplication {
	app.Application
mut:
	fonts &font.Fonts = unsafe { nil }
}

pub fn SampleApplication.create() &SampleApplication {
	mut application := &SampleApplication{}

	application.initialize()

	return application
}

pub fn (mut sample_app SampleApplication) initialize() {
	sample_app.fonts = font.Fonts.create()
}

pub fn (mut sample_app SampleApplication) draw(mut graphics renderer.IRenderer) {
	graphics.set_color(25, 25, 25)
	sample_app.fonts.flush()
	sample_app.fonts.draw_text(mut graphics, text: 'Hello, World!')
}

pub fn (mut sample_app SampleApplication) on_key_down(ev &input.KeyboardEvent) {
	println(ev)
}
