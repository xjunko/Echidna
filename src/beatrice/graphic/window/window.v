module window

import gg // TODO: Configurable backend for graphics
import gx
import sync
import src.beatrice.graphic.backend
import src.beatrice.graphic.sprite
import src.beatrice.component.user_interface
import src.beatrice.component.object

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

	click_fn   gg.FNClick
	unclick_fn gg.FNUnClick
}

[heap]
pub struct CommonWindow {
mut:
	args StartWindowArgument
pub mut:
	backend &backend.GGBackend = unsafe { nil }
	mutex   &sync.Mutex        = sync.new_mutex()
	// Drawables
	sprite_manager &sprite.Manager = sprite.new_manager()
	ui_manager     &user_interface.Manager = user_interface.new_manager()
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

// Events
pub fn (mut window CommonWindow) on_click(x f32, y f32, button gg.MouseButton, _ voidptr) {}

pub fn (mut window CommonWindow) on_unclick(x f32, y f32, button gg.MouseButton, _ voidptr) {}

pub fn (mut window CommonWindow) start(args StartWindowArgument) {
	window.args = args

	// Backend: GG
	mut ctx := gg.new_context(
		width: args.width
		height: args.height
		user_data: window
		// FNs
		// God awful hack
		init_fn: [window.init, args.init_fn][int(!isnil(args.init_fn))]
		frame_fn: [window.draw, args.frame_fn][int(!isnil(args.frame_fn))]
		click_fn: [window.on_click, args.click_fn][int(!isnil(args.click_fn))]
		unclick_fn: [window.on_unclick, args.unclick_fn][int(!isnil(args.unclick_fn))]
	)

	window.backend = &backend.GGBackend{
		ctx: ctx
	}
	window.backend.ctx.fps.show = true

	window.backend.ctx.run()
}
