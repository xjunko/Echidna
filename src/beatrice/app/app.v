module app

import beatrice.engine
import beatrice.engine.input
import beatrice.engine.renderer

pub struct Application {
	input.KeyboardListener
	input.MouseListener
pub mut:
	engine &engine.Engine = unsafe { nil }
}

pub fn Application.create(mut c_engine engine.Engine) &Application {
	return &Application{
		engine: unsafe { c_engine }
	}
}

pub fn (mut app Application) draw(mut graphics renderer.IRenderer) {}

pub fn (mut app Application) update() {}

pub fn (mut app Application) on_key_down(ev &input.KeyboardEvent) {}

pub fn (mut app Application) on_key_up(ev &input.KeyboardEvent) {}

pub fn (mut app Application) on_shutdown() bool {
	return true
}
