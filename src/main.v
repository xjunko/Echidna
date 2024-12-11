module main

import sdl
import beatrice.engine
import beatrice.engine.platform
import beatrice.app.sample

fn main_sdl() {
	// sdl boilerplate
	if sdl.init(sdl.init_everything) < 0 {
		panic('Failed to initialize SDL:' + unsafe { cstring_to_vstring(sdl.get_error()) })
	}

	sdl.gl_set_attribute(.context_flags, int(sdl.GLcontextFlag.forward_compatible_flag))
	sdl.gl_set_attribute(.context_profile_mask, int(sdl.GLprofile.core))
	sdl.gl_set_attribute(.context_major_version, 4)
	sdl.gl_set_attribute(.context_minor_version, 1)

	window_flags := C.SDL_WINDOW_RESIZABLE | C.SDL_WINDOW_HIDDEN | C.SDL_WINDOW_INPUT_FOCUS | C.SDL_WINDOW_MOUSE_FOCUS | C.SDL_WINDOW_FOREIGN | C.SDL_WINDOW_OPENGL

	s_window := sdl.create_window('oyasumi'.str, sdl.windowpos_centered, sdl.windowpos_centered,
		1280, 720, u32(window_flags))

	if isnil(s_window) {
		panic('Failed to create window:' + unsafe { cstring_to_vstring(sdl.get_error()) })
	}

	// gl
	gl_context := sdl.gl_create_context(s_window)
	sdl.gl_make_current(s_window, gl_context)

	// program entry
	sdl.show_window(s_window)
	sdl.raise_window(s_window)

	mut sdl_enviroment := platform.SDLEnviroment.create(s_window)

	mut current_engine := engine.Engine.create(mut sdl_enviroment)

	// Load app here
	mut current_app := sample.SampleApplication.create(mut current_engine)
	// mut current_app := kyukurarin.KyuKurarinApplication.create(mut current_engine)
	current_engine.load_application(mut current_app)

	// main loop
	mut should_close := false
	for {
		current_engine.on_start()

		evt := sdl.Event{}
		for 0 < sdl.poll_event(&evt) {
			match evt.@type {
				.quit {
					should_close = true
					current_engine.on_quit()
				}
				.keydown {
					current_engine.on_key_down(evt.key.keysym.sym)
				}
				.keyup {
					current_engine.on_key_up(evt.key.keysym.sym)
				}
				.mousebuttondown {
					current_engine.on_mouse_button(evt.button)
				}
				.mousebuttonup {
					current_engine.on_mouse_button(evt.button)
				}
				.mousemotion {
					current_engine.on_mouse_motion(evt.motion)
				}
				else {}
			}
		}

		if should_close {
			break
		}

		current_engine.on_update()
		current_engine.on_paint()
		current_engine.limiter.sync()
	}

	// kill
	sdl.destroy_window(s_window)
	sdl.quit()
}

fn main() {
	main_sdl()
}
