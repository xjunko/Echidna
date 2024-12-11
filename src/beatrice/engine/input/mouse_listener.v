module input

pub struct MouseListener {
}

pub fn (mut mouse_listener MouseListener) on_left_change(down bool) {
}

pub fn (mut mouse_listener MouseListener) on_middle_change(down bool) {
}

pub fn (mut mouse_listener MouseListener) on_right_change(down bool) {
}

pub fn (mut mouse_listener MouseListener) on_wheel_x(delta int) {
}

pub fn (mut mouse_listener MouseListener) on_wheel_y(delta int) {
}
