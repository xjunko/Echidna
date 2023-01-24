module window

// TODO: Fix this
import sdl
import sdl.ttf
import gg // TODO: Configurable backend for graphics
import gx
import sync
import beatrice.graphic.backend
import beatrice.graphic.sprite
import beatrice.component.object
import beatrice.graphic.window.input
import beatrice.math.vector

const (
	used_import = backend.i_am_being_used
)

[args; params]
pub struct StartWindowArgument {
pub:
	width  int
	height int
	// im not quite sure how to call parent init_fn so im just gonna
	// pass it thru the start argument and be done with it
	// ez
	init_fn  gg.FNCb
	frame_fn gg.FNCb
}

[heap]
pub struct CommonWindow {
mut:
	args StartWindowArgument
pub mut:
	backend &backend.IBackend    = unsafe { nil }
	input   &input.InputListener = &input.InputListener{}
	mutex   &sync.Mutex = sync.new_mutex()
	// Drawables
	sprite_manager &sprite.Manager = sprite.new_manager()
}

pub fn (mut window CommonWindow) init(_ voidptr) {}

pub fn (mut window CommonWindow) update(time f64) {}

pub fn (mut window CommonWindow) draw(_ voidptr) {
	window.backend.begin()

	window.backend.draw_rect_filled(0, 0, window.args.width, window.args.height, object.GameObjectColor[f64]{58.0, 58.0, 58.0, 255.0})

	// Draw some crap
	window.backend.draw_text(window.args.width / 2, (window.args.height - 100) / 2, 'Hello world!',
		gx.TextCfg{ size: 100, align: .center, color: gx.white })
	window.backend.draw_text(window.args.width / 2, (window.args.height + 50) / 2, 'If you see this then its working, now override this function.',
		gx.TextCfg{ size: 50, align: .center, color: gx.white })

	window.backend.end()
}

// TODO: Move this somewhere
pub fn (mut window CommonWindow) start_gg(args StartWindowArgument) {
	// Backend: GG
	mut ctx := gg.new_context(
		width: args.width
		height: args.height
		user_data: window
		// FNs
		// TODO: fix this, this is awful
		init_fn: [window.init, args.init_fn][int(!isnil(args.init_fn))]
		frame_fn: [window.draw, args.frame_fn][int(!isnil(args.frame_fn))]
		// Mouse
		click_fn: fn (x f32, y f32, button gg.MouseButton, mut window CommonWindow) {
			window.input.mouse.trigger(.mouse_click, .mouse_left, vector.Vector2[f64]{
				x: f64(x)
				y: f64(y)
			})
		}
		unclick_fn: fn (x f32, y f32, button gg.MouseButton, mut window CommonWindow) {
			window.input.mouse.trigger(.mouse_unclick, .mouse_left, vector.Vector2[f64]{
				x: f64(x)
				y: f64(y)
			})
		}
		move_fn: fn (x f32, y f32, mut window CommonWindow) {
			window.input.mouse.trigger(.mouse_move, .mouse_move, vector.Vector2[f64]{
				x: f64(x)
				y: f64(y)
			})
		}
		// Keyboard
		keydown_fn: fn (c gg.KeyCode, m gg.Modifier, mut window CommonWindow) {
			window.input.keyboard.trigger(.key_click, input.ButtonType(c), vector.Vector2[f64]{0.0, 0.0})
		}
		keyup_fn: fn (c gg.KeyCode, m gg.Modifier, mut window CommonWindow) {
			window.input.keyboard.trigger(.key_unclick, input.ButtonType(c), vector.Vector2[f64]{0.0, 0.0})
		}
	)

	window.backend = &backend.GGBackend{
		ctx: ctx
	}

	// Run
	ctx.fps.show = true
	ctx.run()
}

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
	mut font := ttf.open_font('assets/font.ttf'.str, int(20 / 2)) // Follow GG's default font size

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

pub fn (mut window CommonWindow) start(args StartWindowArgument) {
	window.args = args

	$if backend_gg ? {
		window.start_gg(args)
	} $else $if backend_sdl ? {
		window.start_sdl(args)
	} $else {
		window.start_gg(args)
	}
}
