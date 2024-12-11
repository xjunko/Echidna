module input

import beatrice.util.math.vector
import beatrice.engine.renderer

pub interface MouseConsumer {
mut:
	on_left_change(bool)
	on_middle_change(bool)
	on_right_change(bool)

	on_wheel_x(int)
	on_wheel_y(int)
}

pub struct Mouse {
	InputDevice
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

	listeners []&MouseConsumer
}

pub fn (mut mouse Mouse) initialize() {
}

pub fn (mut mouse Mouse) draw(mut graphics renderer.IRenderer) {
}

pub fn (mut mouse Mouse) update() {
}

//
pub fn (mut mouse Mouse) add_listener(listener &MouseConsumer) {
	mouse.listeners << unsafe { listener }
}

// Events
pub fn (mut mouse Mouse) on_left_change(down bool) {
	mouse.left_down = down

	for i := 0; i < mouse.listeners.len; i++ {
		mouse.listeners[i].on_left_change(mouse.left_down)
	}
}

pub fn (mut mouse Mouse) on_middle_change(down bool) {
	mouse.middle_down = down

	for i := 0; i < mouse.listeners.len; i++ {
		mouse.listeners[i].on_middle_change(mouse.middle_down)
	}
}

pub fn (mut mouse Mouse) on_right_change(down bool) {
	mouse.right_down = down

	for i := 0; i < mouse.listeners.len; i++ {
		mouse.listeners[i].on_right_change(mouse.right_down)
	}
}

pub fn Mouse.create() &Mouse {
	mut mouse := &Mouse{}
	mouse.initialize()
	return mouse
}
