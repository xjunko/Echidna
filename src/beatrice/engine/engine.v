module engine

import sdl
import beatrice.app.common
import beatrice.engine.platform
import beatrice.engine.input { Keyboard, Mouse }
import beatrice.engine.renderer { IRenderer }
import beatrice.util.math.timer

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
	mouse            &Mouse           = unsafe { nil }
	graphics         &IRenderer       = unsafe { nil }
	sound_manager    &SoundManager    = unsafe { nil }
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
	engine.mouse = Mouse.create()

	engine.graphics = engine.enviroment.create_renderer()

	engine.debug_log('[Engine] Initializing Subsystems')
	{
		engine.resource_manager = ResourceManager.create(mut engine)
		engine.sound_manager = SoundManager.create()

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
	engine.mouse.add_listener(t)
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
	// Input
	{
		engine.keyboard.update()
		engine.mouse.update()
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
	engine.resource_manager.fonts.flush()

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
	match event.@type {
		.mousebuttonup {
			match event.button {
				1 {
					engine.mouse.on_left_change(false)
				}
				2 {
					engine.mouse.on_middle_change(false)
				}
				3 {
					engine.mouse.on_right_change(false)
				}
				else {}
			}
		}
		.mousebuttondown {
			match event.button {
				1 {
					engine.mouse.on_left_change(true)
				}
				2 {
					engine.mouse.on_middle_change(true)
				}
				3 {
					engine.mouse.on_right_change(true)
				}
				else {}
			}
		}
		else {}
	}
	// engine.debug_log('Mouse button: ${event.button} | Position: ${event.x}, ${event.y}')
}

pub fn (mut engine Engine) on_mouse_motion(event sdl.MouseMotionEvent) {
	engine.mouse.on_mouse_raw_move(f64(event.xrel), f64(event.yrel))
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
