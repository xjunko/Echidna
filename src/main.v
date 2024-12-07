module main

import beatrice.graphic.window

pub struct Window {
	window.CommonWindow
}

fn main() {
	mut basic_window := &Window{}

	basic_window.start(
		width:  1280
		height: 720
	)
}
