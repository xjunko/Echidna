module window

import sdl
import sdl.ttf
import beatrice.graphic.backend

pub fn (mut window CommonWindow) start_sdl(args StartWindowArgument) {
	// Code boilerplate at its finest

	sdl.init(sdl.init_everything)
	ttf.init()

	// sdl.gl_set_attribute(.context_flags, int(sdl.GLcontextFlag.forward_compatible_flag))
	// sdl.gl_set_attribute(.context_profile_mask, int(sdl.GLprofile.core))
	// sdl.gl_set_attribute(.context_major_version, 3)
	// sdl.gl_set_attribute(.context_minor_version, 3)

	// Window
	sdl_window_flags := u32(0)
	mut sdl_window := sdl.create_window('Echidna'.str, sdl.windowpos_undefined, sdl.windowpos_undefined,
		args.width, args.height, sdl_window_flags)

	if sdl_window == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Could not create SDL window, SDL says:\n${error_msg}')
	}

	// Renderer
	mut sdl_renderer := sdl.create_renderer(sdl_window, -1, u32(sdl.RendererFlags.accelerated))

	// Surface
	mut sdl_surface := sdl.get_window_surface(sdl_window)

	if sdl_surface == sdl.null {
		error_msg := unsafe { cstring_to_vstring(sdl.get_error()) }
		panic('Could not create SDL surface, SDL says:\n${error_msg}')
	}

	// Font
	mut font_path := 'assets/font/default.ttf'

	$if font_japanese ? {
		font_path = 'assets/font/japanese.ttf'
	}

	mut font := ttf.open_font(font_path.str, int(20 / 2)) // Follow GG's default font size

	// Backend
	window.backend = &backend.SDLBackend{
		window: sdl_window
		renderer: sdl_renderer
		surface: sdl_surface
		font: font
	}

	// Program Loop
	init_callback := [window.init, args.init_fn][int(!isnil(args.init_fn))]
	draw_callback := [window.draw, args.frame_fn][int(!isnil(args.frame_fn))]

	// Init
	init_callback(voidptr(&window.draw))

	// Run
	mut should_close := false

	for {
		evt := sdl.Event{}
		for 0 < sdl.poll_event(&evt) {
			match evt.@type {
				.quit { should_close = true }
				else {}
			}
		}

		if should_close {
			break
		}

		draw_callback(voidptr(&window.draw))
	}

	sdl.destroy_renderer(sdl_renderer)
	sdl.destroy_window(sdl_window)
	sdl.quit()
}
