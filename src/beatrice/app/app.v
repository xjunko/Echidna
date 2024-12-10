module app

import beatrice.engine.input
import beatrice.engine.renderer

pub struct Application {
	input.KeyboardListener
}

pub fn Application.create() &Application {
	return &Application{}
}

pub fn (mut app Application) draw(mut graphics renderer.IRenderer) {}

pub fn (mut app Application) update() {}

pub fn (mut app Application) on_key_down(ev &input.KeyboardEvent) {}

pub fn (mut app Application) on_key_up(ev &input.KeyboardEvent) {}

pub fn (mut app Application) on_shutdown() bool {
	return true
}
