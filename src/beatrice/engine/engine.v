module engine

import sdl
import beatrice.math.timer
import beatrice.engine.platform
import beatrice.engine.input { Keyboard }
import beatrice.engine.renderer { IRenderer }
import beatrice.app.common

const c_default_fps = 9999

pub struct Engine {
mut:
	enviroment platform.SDLEnviroment

	run_time   f64
	frame_time f64
pub mut:
	app &common.IApplication = unsafe { nil }

	time    &timer.TimeCounter = unsafe { nil }
	limiter &timer.Limiter     = unsafe { nil }

	keyboard         &Keyboard        = unsafe { nil }
	graphics         &IRenderer       = unsafe { nil }
	sound            &SoundManager    = unsafe { nil }
	resource_manager &ResourceManager = unsafe { nil }
}

pub fn (mut engine Engine) debug_log(info string) {
	println('[Engine] ${info}')
}

pub fn (mut engine Engine) initialize() {
	// Timing
	engine.time = &timer.TimeCounter{}
	engine.limiter = &timer.Limiter{c_default_fps, 0, 0}
	engine.frame_time = 1000.0 / f64(c_default_fps)

	// Input
	engine.keyboard = Keyboard.create()

	engine.graphics = engine.enviroment.create_renderer()

	engine.debug_log('[Engine] Initializing Subsystems')
	{
		engine.resource_manager = ResourceManager.create(mut engine)
		engine.sound = SoundManager.create()

		engine.graphics.set_vsync(false)
	}
	// Done
	engine.time.reset()
	engine.time.tick()
}

pub fn (mut engine Engine) load_application[T](mut t T) {
	// App entrypoint
	engine.app = &common.IApplication(t)
	engine.keyboard.add_listener(t)
}

// Events
pub fn (mut engine Engine) on_start() {
}

pub fn (mut engine Engine) on_quit() {
}

pub fn (mut engine Engine) on_update() {
	// Timing
	{
		engine.time.tick()
		engine.run_time = engine.time.get_elapsed_time()
	}
	// Resources
	{
		engine.resource_manager.update()
	}
	// Application
	if !isnil(engine.app) {
		engine.app.update()
	}

	// Enviroment
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
	// engine.debug_log('Mouse button: ${event.button} | Position: ${event.x}, ${event.y}')
}

pub fn (mut engine Engine) on_mouse_motion(event sdl.MouseMotionEvent) {
	// engine.debug_log('Position: ${event.x}, ${event.y}')
}

// Factory
pub fn Engine.create(mut enviroment platform.SDLEnviroment) &Engine {
	mut engine := &Engine{
		enviroment: unsafe { enviroment }
	}

	engine.enviroment.resizable = true
	engine.enviroment.cursor_visible = true

	engine.debug_log('--- [Engine Startup] ---')
	engine.initialize()
	engine.debug_log('[Engine] Hello world!')

	return engine
}
