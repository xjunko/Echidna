module window

// TODO: Fix this
import gx
import sync
import beatrice.graphic.backend
import beatrice.graphic.sprite
import beatrice.component.object
import beatrice.graphic.window.input

const (
	used_import = backend.i_am_being_used
)

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
