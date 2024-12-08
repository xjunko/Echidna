module platform

pub struct Enviroment {
pub mut:
	resizable  bool
	fullscreen bool

	is_cursor_inside bool

	cursor_visible bool
	cursor_clip    bool
}

pub fn (mut enviroment Enviroment) initialize() {
}

pub fn (mut enviroment Enviroment) update() {
}
