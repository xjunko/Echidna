module sample

import beatrice.app
import beatrice.engine.input
import beatrice.engine.renderer

pub struct SampleApplication {
	app.Application
}

pub fn SampleApplication.create() &SampleApplication {
	return &SampleApplication{}
}

pub fn (mut sample_app SampleApplication) draw(mut graphics renderer.IRenderer) {
	graphics.set_color(25, 25, 25)
}
