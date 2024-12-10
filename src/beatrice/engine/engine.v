module engine

import sdl
import beatrice.math.time
import beatrice.engine.platform
import beatrice.engine.input { Keyboard }
import beatrice.engine.renderer { IRenderer }
import beatrice.app.common { IApplication }
import beatrice.app.sample { SampleApplication }

pub struct Engine {
mut:
	enviroment platform.SDLEnviroment
pub mut:
	app &IApplication = unsafe { nil }

	time             &time.TimeCounter = unsafe { nil }
	keyboard         &Keyboard         = unsafe { nil }
	graphics         &IRenderer        = unsafe { nil }
	resource_manager &ResourceManager  = unsafe { nil }
}

pub fn (mut engine Engine) initialize() {
	engine.time = &time.TimeCounter{}
	engine.time.reset()
	engine.time.tick()

	engine.keyboard = Keyboard.create()

	engine.graphics = engine.enviroment.create_renderer()

	engine.resource_manager = ResourceManager.create(mut engine)
}

pub fn (mut engine Engine) load_application() {
	// App entrypoint
	engine.app = SampleApplication.create()
	engine.keyboard.add_listener(engine.app as SampleApplication)
}

// Events
pub fn (mut engine Engine) on_start() {
}

pub fn (mut engine Engine) on_quit() {
}

pub fn (mut engine Engine) on_update() {
	engine.time.tick()

	engine.resource_manager.update()

	if !isnil(engine.app) {
		engine.app.update()
	}

	engine.enviroment.update()
}

pub fn (mut engine Engine) on_paint() {
	engine.graphics.begin()

	if !isnil(engine.app) {
		engine.app.draw(mut engine.graphics)
	}

	engine.graphics.end()
}

// Key
pub fn (mut engine Engine) on_key_down(key sdl.Keycode) {
	engine.keyboard.on_key_down(key)
}

pub fn (mut engine Engine) on_key_up(key sdl.Keycode) {
	engine.keyboard.on_key_up(key)
}

// Mouse
pub fn (mut engine Engine) on_mouse_button(event sdl.MouseButtonEvent) {
	println('Mouse button: ${event.button} | Position: ${event.x}, ${event.y}')
}

pub fn (mut engine Engine) on_mouse_motion(event sdl.MouseMotionEvent) {
	println('Position: ${event.x}, ${event.y}')
}

// Factory
pub fn Engine.create(mut enviroment platform.SDLEnviroment) &Engine {
	mut engine := &Engine{
		enviroment: unsafe { enviroment }
	}

	engine.enviroment.resizable = true
	engine.enviroment.cursor_visible = true

	engine.initialize()

	return engine
}
