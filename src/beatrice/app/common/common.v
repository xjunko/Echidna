module common

import beatrice.engine.input
import beatrice.engine.renderer

pub interface IApplication {
mut:
	draw(mut graphics renderer.IRenderer)
	update()

	on_key_down(ev &input.KeyboardEvent)
	on_key_up(ev &input.KeyboardEvent)

	on_shutdown() bool
}
