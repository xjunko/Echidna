module input

import beatrice.math.vector
import beatrice.engine.renderer

pub struct Mouse {
pub mut:
	position                vector.Vector2[f64]
	position_without_offset vector.Vector2[f64]
	previous_os_mouse_pos   vector.Vector2[f64]
	delta                   vector.Vector2[f64]

	raw_delta                 vector.Vector2[f64]
	raw_delta_actual          vector.Vector2[f64]
	raw_delta_absolute        vector.Vector2[f64]
	raw_delta_absolute_actual vector.Vector2[f64]

	left_down   bool
	middle_down bool
	right_down  bool

	absolute bool

	listeners []&MouseListener
}

pub fn (mut mouse Mouse) initialize() {
}

pub fn (mut mouse Mouse) draw(mut graphics renderer.IRenderer) {
}

pub fn (mut mouse Mouse) update() {
}

pub fn Mouse.create() &Mouse {
	mut mouse := &Mouse{}
	mouse.initialize()
	return mouse
}
