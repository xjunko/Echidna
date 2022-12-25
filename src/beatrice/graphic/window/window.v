module window

import gg // TODO: Configurable backend for graphics
import gx
import sync
import src.beatrice.graphic.backend
import src.beatrice.graphic.sprite
import src.beatrice.component.user_interface_naive
import src.beatrice.component.object
import src.beatrice.graphic.window.input
import src.beatrice.math.vector

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
	backend &backend.GGBackend   = unsafe { nil }
	input   &input.InputListener = &input.InputListener{}
	mutex   &sync.Mutex = sync.new_mutex()
	// Drawables
	sprite_manager &sprite.Manager = sprite.new_manager()
	ui_manager     &user_interface_naive.Manager = user_interface_naive.new_manager()
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

pub fn (mut window CommonWindow) start(args StartWindowArgument) {
	window.args = args

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
	window.backend.ctx.fps.show = true

	window.backend.ctx.run()
}
