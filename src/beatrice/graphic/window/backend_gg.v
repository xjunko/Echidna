module window

import gg // TODO: Configurable backend for graphics
import beatrice.graphic.backend
import beatrice.graphic.window.input
import beatrice.math.vector

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
