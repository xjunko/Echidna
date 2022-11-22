module window

import gg // TODO: Configurable backend for graphics
import gx
import sync
import beatrice.graphic.backend

const (
	used_import = backend.i_am_being_used
)

[args]
[params]
pub struct StartWindowArgument {
	pub:
		width int
		height int

		// im not quite sure how to call parent init_fn so im just gonna
		// pass it thru the start argument and be done with it
		// ez
		init_fn fn (voidptr)
		frame_fn fn (voidptr)
}

[heap]
pub struct CommonWindow {
	mut:
		args StartWindowArgument

	pub mut:
		ctx &gg.Context = unsafe { nil }
		mutex &sync.Mutex = sync.new_mutex()
}

pub fn (mut window CommonWindow) init(_ voidptr) {}

pub fn (mut window CommonWindow) update(time f64) {}

pub fn (mut window CommonWindow) draw(_ voidptr) {
	window.ctx.begin()

	window.ctx.draw_rect_filled(0, 0, window.args.width, window.args.height, gx.gray)

	// Draw some crap
	window.ctx.draw_text(window.args.width / 2, (window.args.height - 100) / 2, "Hello world!", gx.TextCfg{size: 100, align: .center, color: gx.white})
	window.ctx.draw_text(window.args.width / 2, (window.args.height + 50) / 2, "If you see this then its working, now override this function.", gx.TextCfg{size: 50, align: .center, color: gx.white})

	window.ctx.end()
}

pub fn (mut window CommonWindow) start(args StartWindowArgument) {
	window.args = args


	// Backend: GG
	window.ctx = gg.new_context(
		width: args.width,
		height: args.height
		user_data: window

		// FNs
		init_fn: [window.init, args.init_fn][int(!isnil(args.init_fn))], // God awful hack
		frame_fn: [window.draw, args.frame_fn][int(!isnil(args.frame_fn))] // God awful hack
	)

	window.ctx.run()
}
